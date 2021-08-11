module Civ
  # Coodinates scene loading, orders, and passing between scenes.
  class SceneManager
    attr_accessor :curr_scene, :scene_queue, :scene_tick

    def initialize(_args)
      @scene_time = 0
      @scene_queue = [:main]
      @current_scene = nil
    end

    def tick(_args)
      # Find design for scene switching
      $game.draw.static_draw << { x: 500, y: 500, text: 'Hello from Scene Manager', primitive_marker: :label }
      @scene_tick += 1
    end

    def scene_adv
      @curr_scene = @scene_queue[0]
      @scene_queue = @scene_queue.shift
      @scene_time = 0
    end
  end
end
