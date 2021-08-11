module Civ
  # Highest level game class. main.rb initializes then directs tick and args here.
  # All code and ojects should originate from Game if possible.
  class Game
    attr_accessor :do_debug, :game_tick, :scene_manager, :draw

    def initialize(args)
      @do_debug = false
      @game_tick = 0
      @scene_manager = Civ::Scene_Manager.new(args)
      @draw = Civ::Draw.new
    end

    def tick(args)
      @scene_manager.tick(args)
      @draw.tick(args)

      debug(args)
      @game_tick += 1
    end

    def debug(args)
      @do_debug = !@do_debug if args.inputs.keyboard.key_up.tab
      return unless @do_debug

      debug_prims = []
      debug_prims << args.gtk.framerate_diagnostics_primitives
      debug_prims << { x: 0, y: 20, text: "Game Tick:  #{@game_tick}", primitive_marker: :label }
      debug_prims << { x: 0, y: 40, text: "Scene Tick: #{@scene_manager.scene_tick}", primitive_marker: :label }

      args.outputs.debug << debug_prims
    end
  end
end

Civ.extend Civ
