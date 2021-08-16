module Civ
  # Coodinates scene loading, orders, and passing between scenes.
  class SceneManager
    attr_accessor :curr_scene, :scenes, :scene_tick, :next_scene

    def initialize(_args)
      @scene_tick = 0
      @scenes = {}

      @scenes[:main] = SceneMain.new
      @curr_scene = @scenes[:main]
      @next_scene = nil
      @once_done = false
    end

    def once(_args)
      @once_done = true
    end

    def tick(args)
      once(args) unless @once_done
      if @next_scene
        @scene_tick = 0
        @curr_scene = @next_scene
        @next_scene = nil
      end

      @curr_scene.tick(args)

      @scene_tick += 1
    end
  end
end
