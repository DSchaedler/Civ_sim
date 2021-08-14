module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    attr_accessor :name

    def initialize
      @name = 'Main'
      @once_done = false
      @tile_x = 0
      @tile_y = 0
      @new_tiles = false
    end

    def once(args)
      debug_once(args)

      args.render_target(:field).sprites << SCREEN_WIDTH.map_with_index do |x|
        SCREEN_HEIGHT.map_with_index do |y|
          { x: x * GRID_SIZE, y: y * GRID_SIZE }.merge(GRASS_SPRITES.sample)
        end
      end

      args.state.x = 0
      args.state.y = 0
      @once_done = true
    end

    def tick(args)
      once(args) if @once_done == false

      @tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      @tile_y = (args.inputs.mouse.y / GRID_SIZE).floor

      $game.draw.layers[0] ||= [] # Background Layer
      $game.draw.layers[1] ||= [] # Modified Tiles
      $game.draw.layers[2] ||= [] # Active Layer
      $game.draw.layers[3] ||= [] # UI Layer

      $game.draw.layers[0] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :field }

      $game.draw.layers[2] << { x: 4 * GRID_SIZE, y: 4 * GRID_SIZE,
                                source_x: args.state.x * (SPRITE_WIDTH + MARGIN),
                                source_y: args.state.y * (SPRITE_HEIGHT + MARGIN) }.merge(BASE_SPRITE)

      $game.draw.layers[2] << { x: 4 * GRID_SIZE, y: 4 * GRID_SIZE, text: "x: #{args.state.x} y: #{args.state.y}", primitive_marker: :label }

      args.state.x += 1 if args.inputs.keyboard.key_up.right
      args.state.x -= 1 if args.inputs.keyboard.key_up.left
      args.state.y += 1 if args.inputs.keyboard.key_up.up
      args.state.y -= 1 if args.inputs.keyboard.key_up.down

      tile_hover(args)

      $game.draw.layers[1] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :new_tiles, primitive_marker: :sprite } if @new_tiles

      debug(args)
    end

    def tile_hover(args)
      $game.draw.layers[3] << { x: @tile_x * GRID_SIZE, y: @tile_y * GRID_SIZE }.merge(SPRITE_CURSOR)

      args.state.layer2 ||= []
      args.state.layer2[@tile_x] ||= []
      left_click(args) if args.inputs.mouse.button_left
      right_click(args) if args.inputs.mouse.button_right
    end

    def left_click(args)
      new_tile = { x: @tile_x * GRID_SIZE, y: @tile_y * GRID_SIZE,
                   source_x: args.state.x * (SPRITE_WIDTH + MARGIN), source_y: args.state.y * (SPRITE_HEIGHT + MARGIN) }.merge(BASE_SPRITE)

      return unless new_tile != args.state.layer2[@tile_x][@tile_y]
      args.state.layer2[@tile_x][@tile_y] = new_tile
      @new_tiles = true
      update_tiles(args)
    end

    def right_click(args)
      return unless args.state.layer2[@tile_x][@tile_y]
      args.state.layer2[@tile_x][@tile_y] = nil
      update_tiles(args)
    end

    def update_tiles(args)
      args.state.render_target(:new_tiles).sprites.clear if args.state.render_target(:new_tiles)
      args.state.layer2.each do |row|
        next unless row
        row.each do |tile|
          args.render_target(:new_tiles).sprites << tile
        end
      end
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
      $game.draw.debug_layer << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :scene_main_debug }
      $game.draw.debug_layer << { x: 0, y: 80, text: "Tile #{@tile_x}, #{@tile_y}", primitive_marker: :label }
    end
  end
end
