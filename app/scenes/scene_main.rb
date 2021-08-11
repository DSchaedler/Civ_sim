module Civ
  # Scene that plays when the game loads
  # Currently for prototyping
  class SceneMain
    def initializeargs; end

    def tick(_args)
      $game.draw.draw << { x: 500, y: 500, text: 'Hello from SceneMain', primitive_marker: :label }
    end
  end
end
