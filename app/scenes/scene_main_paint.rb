module Civ
  # Scene for editing SceneMain
  class SceneMainPaint
    attr_gtk

    TILE_OFFSET = 2

    SCALED_SCREEN_WIDTH = (1280 / GRID_SIZE) + TILE_OFFSET
    SCALED_SCREEN_HEIGHT = (720 / GRID_SIZE) + TILE_OFFSET
    SCALED_GRID_X = 1280 / SCALED_SCREEN_WIDTH
    SCALED_GRID_Y = 720 / SCALED_SCREEN_HEIGHT

    OFFSET_MARGIN_X = TILE_OFFSET * SCALED_GRID_X
    OFFSET_MARGIN_Y = TILE_OFFSET * SCALED_GRID_Y

    attr_accessor :name

    def initialize(_args)
      @name = 'mainPaint'
      @once_done = false
      @tile_x = 0
      @tile_y = 0
      @cursor_x = 0
      @cursor_y = 0
      @map_tile_x = 0
      @map_tile_y = 0
    end

    def once(args)
      @once_done = true

      debug_once(args)
    end

    def tick(args)
      @main = $game.scene_manager.scenes[:main]
      once(args) if @once_done == false
      calc(args)
      draw(args)
    end

    def calc(args)
      @tile_x = (args.inputs.mouse.x / SCALED_GRID_X).floor
      @tile_y = (args.inputs.mouse.y / SCALED_GRID_Y).floor

      @map_tile_x = @tile_x - 2
      @map_tile_y = @tile_y - 2

      paint_mode(args)

      return unless args.inputs.keyboard.key_up.p

      $game.scene_manager.next_scene = $game.scene_manager.scenes[:main]
    end

    def draw(args)
      debug(args)
      args.gtk.hide_cursor

      $game.draw.layers[0] << { x: OFFSET_MARGIN_X, y: OFFSET_MARGIN_Y,
                                w: args.grid.w - OFFSET_MARGIN_X,
                                h: args.grid.h - OFFSET_MARGIN_Y, path: :field }
      $game.draw.layers[3] << { x: @tile_x * SCALED_GRID_X,
                                y: @tile_y * SCALED_GRID_Y }
                              .merge(SPRITE_CURSOR)
      $game.draw.layers[3] << { x: args.inputs.mouse.x - 8,
                                y: args.inputs.mouse.y - 8 }
                              .merge(SPRITE_MOUSE_CURSOR)
      return unless @main.new_tiles

      $game.draw.layers[1] << { x: OFFSET_MARGIN_X, y: OFFSET_MARGIN_Y,
                                w: args.grid.w - OFFSET_MARGIN_X,
                                h: args.grid.h - OFFSET_MARGIN_Y,
                                path: :new_tiles, primitive_marker: :sprite }
    end

    # Paint Mode

    def paint_mode(args)
      $game.draw.layers[2] << { x: 0, y: args.grid.top - SCALED_GRID_Y,
                                source_x: @cursor_x * (SPRITE_WIDTH + MARGIN),
                                source_y: @cursor_y * (SPRITE_HEIGHT + MARGIN) }
                              .merge(BASE_SPRITE)

      $game.draw.layers[2] << { x: 0, y: args.grid.top - SCALED_GRID_X,
                                text: "x: #{@cursor_x}",
                                primitive_marker: :label }
      $game.draw.layers[2] << { x: 0, y: args.grid.top - SCALED_GRID_Y - 20,
                                text: "y: #{@cursor_y}",
                                primitive_marker: :label }

      @cursor_x += 1 if args.inputs.keyboard.key_up.right
      @cursor_x -= 1 if args.inputs.keyboard.key_up.left
      @cursor_y += 1 if args.inputs.keyboard.key_up.up
      @cursor_y -= 1 if args.inputs.keyboard.key_up.down

      return unless @map_tile_x >= 0
      return unless @map_tile_y >= 0
      @main.layer2[@map_tile_x] ||= []
      left_click(args) if args.inputs.mouse.button_left
      right_click(args) if args.inputs.mouse.button_right
    end

    def left_click(args)
      new_tile = { x: @map_tile_x * GRID_SIZE, y: @map_tile_y * GRID_SIZE,
                   source_x: @cursor_x * (SPRITE_WIDTH + MARGIN),
                   source_y: @cursor_y * (SPRITE_HEIGHT + MARGIN) }
                 .merge(BASE_SPRITE)

      return unless new_tile != @main.layer2[@map_tile_x][@map_tile_y]
      @main.layer2[@map_tile_x][@map_tile_y] = new_tile
      @main.new_tiles = true
      update_tiles(args)
    end

    def right_click(args)
      return unless @main.layer2[@map_tile_x][@map_tile_y]
      @main.layer2[@map_tile_x][@map_tile_y] = nil
      update_tiles(args)
    end

    def update_tiles(args)
      args.outputs[:new_tiles].sprites.clear if args.outputs[:new_tiles]
      @main.layer2.each do |row|
        next unless row
        row.each do |tile|
          args.outputs[:new_tiles].sprites << tile
        end
      end
    end

    # Debug

    def debug_once(args)
      debug = []

      (args.grid.w / GRID_SIZE).map_with_index do |x|
        debug << { x: x * GRID_SIZE, y: 0, x2: x * GRID_SIZE,
                   y2: args.grid.top, primitive_marker: :line }
      end
      (args.grid.h / GRID_SIZE).map_with_index do |y|
        debug << { x: 0, y: y * GRID_SIZE, x2: args.grid.right,
                   y2: y * GRID_SIZE, primitive_marker: :line }
      end
      args.outputs[:scene_main_paint_debug].lines << debug
    end

    def debug(args)
      return unless $game.do_debug
      $game.draw.debug_layer << { x: OFFSET_MARGIN_X, y: OFFSET_MARGIN_Y,
                                  w: args.grid.w - OFFSET_MARGIN_X,
                                  h: args.grid.h - OFFSET_MARGIN_Y,
                                  path: :scene_main_paint_debug }
      $game.draw.debug_layer << { x: 0, y: 80,
                                  text: "Tile #{@tile_x}, #{@tile_y}",
                                  primitive_marker: :label }
    end
  end
end
