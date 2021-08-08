module Civ_Sim
  # Shared functionality across game scenes
  class MetaScene < Zif::Scene
    include Zif::Traceable

    attr_accessor :tracer_service_name, :scene_timer, :next_scene

    def initialize
      @tracer_service_name = :tracer
    end

    def preprare_scene
      # Clear Zif registers when the scene changes
      $game.services[:action_service].reset_actionables
      $game.services[:input_service].reset
      tracer.clear_averages
      $gtk.args.outputs.static_sprites.clear
      $gtk.args.outputs.static_labels.clear
      @timer_bar_set = false
    end

    def perform_tick
      $game.services[:tracer].clear_averages if $gtk.args.inputs.keyboard.key_up.delete
    end
  end
end
