module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    attr_accessor :name

    GRID_SIZE = 80

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
      $game.draw.static_draw << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :field }
      $game.draw.static_draw << { x: 500, y: 400, text: 'Hello from SceneMain', primitive_marker: :label }

      NineTile.nine_tile(args, w: 300, h: 300, source_x: 11 * 128, source_y: 11 * 128, source_w: 384, path: 'app/sprites/RPGpack_sheet_2X.png', symbol: :lake)
      $game.draw.static_draw << { x: 300, y: 300, w: 384, h: 384, path: :lake }
    end

    def tick(args)
      once(args) unless @once_done

      debug(args)
    end

    def debug_once(args)
      debug = []

      (args.grid.w / GRID_SIZE).map_with_index do |x|
        debug << { x: x * GRID_SIZE, y: 0, x2: x * GRID_SIZE, y2: args.grid.top, primitive_marker: :line}
      end
      (args.grid.h / GRID_SIZE).map_with_index do |y|
        debug << { x: 0, y: y * GRID_SIZE, x2: args.grid.right, y2: y * GRID_SIZE, primitive_marker: :line}
      end
      args.render_target(:scene_main_debug).lines << debug
    end

    def debug(args)
      return unless $game.do_debug
      args.outputs.debug << {x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :scene_main_debug}
    end
  end
end
