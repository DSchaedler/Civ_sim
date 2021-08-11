module NineTile
  def nine_tile(args, w:, h:, source_x:, source_y:, source_w:, path:, symbol:)
    sprite_size = source_w / 3
    tiles_x = w / sprite_size
    tiles_y = h / sprite_size
    nine_tile_prims = []

    # Lower Left
    nine_tile_prims << {
      x: 0,
      y: 0,
      w: sprite_size,
      h: sprite_size,
      path: path,
      source_x: source_x,
      source_y: source_y,
      source_w: sprite_size,
      source_h: sprite_size
    }

    # Lower Center
    tiles_x_c = tiles_x - 2
    nine_tile_prims << tiles_x_c.map_with_index do |x|
      { x: x * sprite_size + 128,
        y: 0,
        w: sprite_size,
        h: sprite_size,
        path: path,
        source_x: source_x + sprite_size,
        source_y: sprite_size,
        source_w: sprite_size,
        source_h: sprite_size }
    end
    # Lower Right

    # Center Left

    # Center
    tiles_x_c = tiles_x - 2
    tiles_y_c = tiles_y - 2
    nine_tile_prims << tiles_x_c.map_with_index do |x|
      tiles_y_c.map_with_index do |y|
        { x: x * sprite_size + 256,
          y: y * sprite_size + 256,
          w: sprite_size,
          h: sprite_size,
          path: path,
          source_x: source_x + sprite_size,
          source_y: source_y + sprite_size,
          source_w: sprite_size,
          source_h: sprite_size }
      end
    end

    # Center Right

    # Upper Left
    # Upper Center
    # Upper Right
    #
    # Construct Render Target
    args.render_target(symbol).sprites << nine_tile_prims
  end
end

NineTile.extend NineTile
