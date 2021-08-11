module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    attr_accessor :name

    def initialize
      @name = 'Main'
      @once_done = false
    end

    def once(_args)
      $game.draw.static_draw << { x: 500, y: 400, text: 'Hello from SceneMain', primitive_marker: :label }
    end

    def tick(args)
      once(args) unless @once_done
    end
  end
end
