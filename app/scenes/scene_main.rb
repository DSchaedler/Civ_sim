module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    # Init Stuff
    attr_accessor :name, :new_tiles, :layer2, :tile_x, :tile_y

    def initialize
      @name = 'Main'
      @once_done = false
      @tile_x = 0
      @tile_y = 0
      @new_tiles = false
      @layer2 = []
      @mouse = { x: $gtk.args.inputs.mouse.x, y: $gtk.args.inputs.mouse.y }
    end

    def once(args)
      debug_once(args)

      args.render_target(:field).sprites << SCREEN_WIDTH.map_with_index do |x|
        SCREEN_HEIGHT.map_with_index do |y|
          { x: x * GRID_SIZE, y: y * GRID_SIZE }.merge(GRASS_SPRITES.sample)
        end
      end

      $game.draw.layers = [[], [], [], []]

      @once_done = true
    end

    # Main Loop

    def tick(args)
      once(args) if @once_done == false

      mouse_move(args)

      calc(args)
      draw(args)
    end

    def calc(args)
      @tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      @tile_y = (args.inputs.mouse.y / GRID_SIZE).floor

      $game.scene_manager.next_scene = Civ.scene_main_paint if keyboard.key_up.p
    end

    def mouse_move(args)
      mouse = { x: args.inputs.mouse.x, y: args.inputs.mouse.y }
      return unless @mouse != mouse

      @mouse = mouse
    end

    # UI

    def draw(args)
      debug(args)

      $game.draw.layers[0] << { x: 0, y: 0, w: 1280, h: 720, path: :field }
      $game.draw.layers[3] << { x: @tile_x * GRID_SIZE, y: @tile_y * GRID_SIZE }
                              .merge(SPRITE_CURSOR)

      # args.gtk.hide_cursor
      # $game.draw.layers[3] << { x: @mouse.x - GRID_SIZE / 2,
      #                           y: @mouse.y - GRID_SIZE / 2 }
      #                         .merge(SPRITE_MOUSE_CURSOR)
      return unless @new_tiles

      $game.draw.layers[1] << { x: 0, y: 0, w: 1280, h: 720, path: :new_tiles,
                                primitive_marker: :sprite }
    end

    # Debug

    def debug_once(args)
      debug = args.outputs[:scene_main_debug].lines

      (args.grid.w / GRID_SIZE).map_with_index do |x|
        debug << { x: x * GRID_SIZE, y: 0, x2: x * GRID_SIZE,
                   y2: args.grid.top, primitive_marker: :line }
      end
      (args.grid.h / GRID_SIZE).map_with_index do |y|
        debug << { x: 0, y: y * GRID_SIZE, x2: args.grid.right,
                   y2: y * GRID_SIZE, primitive_marker: :line }
      end
    end

    def debug(_args)
      return unless $game.do_debug
      $game.draw.debug_layer << { x: 0, y: 0, w: 1280, h: 720,
                                  path: :scene_main_debug }
      $game.draw.debug_layer << { x: 0, y: 80,
                                  text: "Tile #{@tile_x}, #{@tile_y}",
                                  primitive_marker: :label }
    end
  end
end

Civ.extend Civ
