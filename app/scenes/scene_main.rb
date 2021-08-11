module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    attr_accessor :name

    def initialize
      @name = 'Main'
      @once_done = false
    end

    def once(args)
      @once_done = true
      debug_once(args)

      grass = [SPRITE_GRASS_A, SPRITE_GRASS_B, SPRITE_GRASS_C]
      args.render_target(:field).sprites << SCREEN_WIDTH.map_with_index do |x|
        SCREEN_HEIGHT.map_with_index do |y|
          { x: x * GRID_SIZE, y: y * GRID_SIZE }.merge(grass.sample)
        end
      end
      $game.draw.static_layer << { x: 500, y: 400, text: 'Hello from SceneMain', primitive_marker: :label }

      NineTile.nine_tile(args, w: 300, h: 300, source_x: 11 * 128, source_y: 11 * 128, source_w: 384, path: 'app/sprites/RPGpack_sheet_2X.png', symbol: :lake)
      $game.draw.static_layer << { x: 300, y: 300, w: 384, h: 384, path: :lake }
    end

    def tick(args)
      once(args) unless @once_done

      args.state.x ||= 0
      args.state.y ||= 0

      $game.draw.layers[1] ||= []
      $game.draw.layers[1] << {
        x: 648,
        y: 360,
        w: GRID_SIZE,
        h: GRID_SIZE,
        path: 'app/sprites/roguelikeCity_transparent.png',
        source_x: args.state.x * (SPRITE_WIDTH + MARGIN),
        source_y: args.state.y * (SPRITE_HEIGHT + MARGIN),
        source_w: SPRITE_WIDTH,
        source_h: SPRITE_HEIGHT,
        primitve_marker: :sprite
      }

      $game.draw.layers[0] ||= []
      $game.draw.layers[0] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :field }

      $game.draw.layers[1] << { x: 648, y: 360, text: "x: #{args.state.x} y: #{args.state.y}", primitive_marker: :label }

      args.state.x += 1 if args.inputs.keyboard.key_up.right
      args.state.x -= 1 if args.inputs.keyboard.key_up.left
      args.state.y += 1 if args.inputs.keyboard.key_up.up
      args.state.y -= 1 if args.inputs.keyboard.key_up.down

      if args.state.tick_count % 180 == 0
        args.state.x += 1
        if args.state.x > 40
          args.state.y += 1
          args.state.x = 0
          args.state.y = 0 if args.state.y > 30
        end
      end

      tile_hover(args)

      debug(args)
    end

    def tile_hover(args)
      tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      tile_y = (args.inputs.mouse.y / GRID_SIZE).floor
      $game.draw.layers[1] << { x: tile_x * GRID_SIZE,
                                y: tile_y * GRID_SIZE,
                                w: GRID_SIZE,
                                h: GRID_SIZE,
                                path: 'app/sprites/selectionCursor.png',
                                primitive_marker: :sprite }
    end

    def debug_once(args)
      debug = []

      (args.grid.w / GRID_SIZE).map_with_index do |x|
        debug << { x: x * GRID_SIZE, y: 0, x2: x * GRID_SIZE, y2: args.grid.top, primitive_marker: :line }
      end
      (args.grid.h / GRID_SIZE).map_with_index do |y|
        debug << { x: 0, y: y * GRID_SIZE, x2: args.grid.right, y2: y * GRID_SIZE, primitive_marker: :line }
      end
      args.render_target(:scene_main_debug).lines << debug
    end

    def debug(args)
      return unless $game.do_debug
      args.outputs.debug << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :scene_main_debug }
      args.outputs.debug << { x: 0, y: 80, text: "Tile #{(args.inputs.mouse.x / GRID_SIZE).floor}, #{(args.inputs.mouse.y / GRID_SIZE).floor}", primitive_marker: :label }
    end
  end
end
