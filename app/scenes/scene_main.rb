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
    end

    def once(args)
      debug_once(args)

      args.render_target(:field).sprites << SCREEN_WIDTH.map_with_index do |x|
        SCREEN_HEIGHT.map_with_index do |y|
          { x: x * GRID_SIZE, y: y * GRID_SIZE }.merge(GRASS_SPRITES.sample)
        end
      end

      $game.scene_manager.scenes[:mainPaint] ||= SceneMainPaint.new(args)

      $game.draw.layers = [[], [], [], []]

      @once_done = true
    end

    # Main Loop

    def tick(args)
      once(args) if @once_done == false
      calc(args)
      draw(args)
    end

    def calc(args)
      @tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      @tile_y = (args.inputs.mouse.y / GRID_SIZE).floor

      $game.scene_manager.next_scene = $game.scene_manager.scenes[:mainPaint] if args.inputs.keyboard.key_up.p
    end

    # UI

    def draw(args)
      $game.draw.layers[0] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :field }
      $game.draw.layers[3] << { x: @tile_x * GRID_SIZE, y: @tile_y * GRID_SIZE }.merge(SPRITE_CURSOR)
      args.gtk.hide_cursor
      $game.draw.layers[3] << { x: args.inputs.mouse.x - GRID_SIZE / 2, y: args.inputs.mouse.y - GRID_SIZE / 2 }.merge(SPRITE_MOUSE_CURSOR)
      $game.draw.layers[1] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :new_tiles, primitive_marker: :sprite } if @new_tiles
      debug(args)
    end

    # Debug

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
      $game.draw.debug_layer << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :scene_main_debug }
      $game.draw.debug_layer << { x: 0, y: 80, text: "Tile #{@tile_x}, #{@tile_y}", primitive_marker: :label }
    end
  end
end
