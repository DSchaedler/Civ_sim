module Civ
  # Highest level game class.
  # main.rb initializes then directs tick and args here.
  # All code and ojects should originate from Game if possible.
  class Game
    attr_accessor :do_debug, :game_tick, :scene_manager, :draw

    def initialize(args)
      @do_debug = false
      @game_tick = 0
      @scene_manager = Civ::SceneManager.new(args)
      @draw = Civ::Draw.new(args)
      @once_done = false
    end

    def once(_args)
      @once_done = true
    end

    def tick(args)
      once(args) if @once_done == false

      @scene_manager.tick(args)
      @draw.tick(args)

      screenshots(args)

      @do_debug = !@do_debug if args.inputs.keyboard.key_up.tab
      debug(args) if @do_debug

      @game_tick += 1
    end

    def debug(args)
      debug_layer = $game.draw.debug_layer
      debug_layer << args.gtk.framerate_diagnostics_primitives
      debug_layer << { x: 0, y: 20, text: "Game Tick:  #{@game_tick}",
                       primitive_marker: :label }
      debug_layer << { x: 0, y: 40, text: "Scene Tick: #{@scene_manager
                                    .scene_tick}",
                       primitive_marker: :label }
      debug_layer << { x: 0, y: 60, text: "Scene:      #{@scene_manager
                                    .curr_scene.name}",
                       primitive_marker: :label }
    end
  end
end

Civ.extend Civ
