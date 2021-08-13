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
      tiles_x = args.grid.w / GRID_SIZE
      tiles_y = args.grid.h / GRID_SIZE
      args.render_target(:field).sprites << tiles_x.map_with_index do |x|
        tiles_y.map_with_index do |y|
          { x: x * GRID_SIZE, y: y * GRID_SIZE }.merge(grass.sample)
        end
      end
    end

    def tick(args)
      once(args) unless @once_done

      $game.draw.layers[0] ||= [] # Background Layer
      $game.draw.layers[1] ||= [] # Modified Tiles
      $game.draw.layers[2] ||= [] # Active Layer
      $game.draw.layers[3] ||= [] # UI Layer

      args.state.x ||= 0
      args.state.y ||= 0

      $game.draw.layers[0] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :field }

      $game.draw.layers[2] << {
        x: 4 * GRID_SIZE,
        y: 4 * GRID_SIZE,
        w: GRID_SIZE,
        h: GRID_SIZE,
        path: 'app/sprites/roguelikeCity_transparent.png',
        source_x: args.state.x * (SPRITE_WIDTH + MARGIN),
        source_y: args.state.y * (SPRITE_HEIGHT + MARGIN),
        source_w: SPRITE_WIDTH,
        source_h: SPRITE_HEIGHT,
        primitve_marker: :sprite
      }

      $game.draw.layers[2] << { x: 4 * GRID_SIZE, y: 4 * GRID_SIZE,
                                text: "x: #{args.state.x} y: #{args.state.y}", primitive_marker: :label }

      args.state.x += 1 if args.inputs.keyboard.key_up.right
      args.state.x -= 1 if args.inputs.keyboard.key_up.left
      args.state.y += 1 if args.inputs.keyboard.key_up.up
      args.state.y -= 1 if args.inputs.keyboard.key_up.down

      tile_hover(args)

      args.state.layer2 ||= []
      if args.inputs.mouse.button_left
        tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
        tile_y = (args.inputs.mouse.y / GRID_SIZE).floor
        args.state.layer2[tile_x] ||= []
        args.state.layer2[tile_x][tile_y] = {
          x: tile_x * GRID_SIZE,
          y: tile_y * GRID_SIZE,
          w: GRID_SIZE,
          h: GRID_SIZE,
          path: 'app/sprites/roguelikeCity_transparent.png',
          source_x: args.state.x * (SPRITE_WIDTH + MARGIN),
          source_y: args.state.y * (SPRITE_HEIGHT + MARGIN),
          source_w: SPRITE_WIDTH,
          source_h: SPRITE_HEIGHT,
          primitve_marker: :sprite
        }
        args.render_target(:new_tiles).sprites.clear
        args.state.layer2.each { |row|
          if row
            row.each {|tile|
              args.render_target(:new_tiles).sprites << tile if tile
          }
          end
        }

      end

      $game.draw.layers[1] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :new_tiles, primitive_marker: :sprite } if args.state.layer2 != []

      debug(args)
    end

    def tile_hover(args)
      tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      tile_y = (args.inputs.mouse.y / GRID_SIZE).floor
      $game.draw.layers[3] << {
        x: tile_x * GRID_SIZE,
        y: tile_y * GRID_SIZE
      }.merge(SPRITE_CURSOR)
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
      tile_x = (args.inputs.mouse.x / GRID_SIZE).floor
      tile_y = (args.inputs.mouse.y / GRID_SIZE).floor
      $game.draw.debug_layer << { x: 0, y: 0, w: args.grid.w, h: args.grid.h, path: :scene_main_debug }
      $game.draw.debug_layer << { x: 0, y: 80, text: "Tile #{tile_x}, #{tile_y}", primitive_marker: :label }
    end
  end
end
