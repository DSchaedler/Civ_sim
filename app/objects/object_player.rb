module Civ
  class Object_Player < Object_Base_Object
    def initialize
      super
      @name = 'Player'
      @pos = { x: 1280 / 2, y: 720 / 2 }
      @speed = 5

      @player_sprite = SPRITE_PLAYER_F

      @once_done = false
    end

    def once
      @once_done = true
    end

    def tick
      once if @once_done == false

      vector = $gtk.args.inputs.keyboard.directional_vector

      if vector
        @pos.x += (vector.x * @speed).round
        @pos.y += (vector.y * @speed).round

        if vector.x.positive?
          @player_sprite = SPRITE_PLAYER_R
        elsif vector.x.negative?
          @player_sprite = SPRITE_PLAYER_L
        end

        if vector.y.positive?
          @player_sprite = SPRITE_PLAYER_B
        elsif vector.y.negative?
          @player_sprite = SPRITE_PLAYER_F
        end

      end

      draw
      debug
    end

    def draw
      $game.draw.layers[2] << {
        x: @pos.x,
        y: @pos.y
      }.merge(@player_sprite)
    end

    def debug
      return unless $game.do_debug

      $game.draw.debug_layer << { x: 0, y: 100, text: "Player: x #{@pos.x}, y #{@pos.y}", primitive_marker: :label }
    end
  end
end

Civ.extend Civ
