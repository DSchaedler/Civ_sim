module Civ
  # Tile picker for SceneMainPaint
  class SceneMainPaintPick
    attr_accessor :name

    def initialize
      @name = 'mainPaint'
      @once_done = false

      @scaled_grid_x = 951 / (628 / 17)
      @scaled_grid_y = 720 / (475 / 17)
    end

    def once(args)
      @once_done = true

      args.outputs[:picker_background].solids << {
        x: 0, y: 0, w: 1280, h: 720,
        r: 255, g: 0, b: 255, primitive_marker: :solid
      }

      args.outputs[:sprite_sheet].sprites << {
        x: 0, y: 0, w: 1280, h: 720,
        path: 'app/sprites/roguelikeCity_transparent.png',
        primitive_marker: :sprite
      }
    end

    def tick(args)
      @main = Civ.scene_main
      @paint_mode = Civ.scene_main_paint
      once(args) if @once_done == false

      calc(args)

      draw(args)
      draw_cursor(args)

      left_click(args) if args.inputs.mouse.up

      return unless args.inputs.keyboard.key_up.escape
      $game.scene_manager.next_scene = Civ.scene_main_paint
    end

    def calc(args)
      @tile_x = (args.inputs.mouse.x / @scaled_grid_x).floor
      @tile_y = (args.inputs.mouse.y / @scaled_grid_y).floor
    end

    def left_click(_args)
      @paint_mode.cursor_x = @tile_x
      @paint_mode.cursor_y = @tile_y
      $game.scene_manager.next_scene = Civ.scene_main_paint
    end

    def draw_cursor(_args)
      $game.draw.layers[3] << { x: @tile_x * @scaled_grid_x,
                                y: @tile_y * @scaled_grid_y }
                              .merge(SPRITE_CURSOR)
                              .merge(w: @scaled_grid_x,
                                     h: @scaled_grid_y)
    end

    def draw(_args)
      $game.draw.layers[0] << {
        x: 0, y: 0,
        w: 951, h: 720,
        path: :picker_background, primitive_marker: :sprite
      }
      $game.draw.layers[0] << {
        x: 0, y: 0,
        w: 951, h: 720,
        path: :sprite_sheet, primitive_marker: :sprite
      }
    end
  end
end

Civ.extend Civ
