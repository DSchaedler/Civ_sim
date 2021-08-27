module Civ
  class Object_Player < Object_Base_Object
    def initialize
      super
      @name = 'Player'
      @pos = { x: 1280 / 2, y: 720 / 2 }
      @speed = 10

      @once_done = false
    end

    def once
      @once_done = true

    end

    def tick
      once if @once_done == false

      vector = $gtk.args.inputs.keyboard.directional_vector
      @pos.x += (vector.x * @speed).round if vector
      @pos.y += (vector.y * @speed).round if vector

      draw
      debug
    end

    def draw
      # $game.draw.layers[2] << {
      #  x: @pos.x,
      #  y: @pos.y,
      #  w: 1280,
      #  h: 720,
      #  path: :player_sprite,
      #  primitive_marker: :sprite
      # }
      $game.draw.layers[2] << {
        x: @pos.x,
        y: @pos.y
      }.merge(SPRITE_PLAYER)
    end

    def debug
      return unless $game.do_debug

      $game.draw.debug_layer << { x: 0, y: 100, text: "Player: x #{@pos.x}, y #{@pos.y}", primitive_marker: :label }
    end
  end
end

Civ.extend Civ
