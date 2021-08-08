DEBUG_LABEL_COLOR = [255, 0, 0]

module Civ_sim
  class UISample < MetaScene
    def initialize
      super
    end

    # #prepare_scene and #unload_scene are called by Game before the scene is run, and after a change is detected
    def prepare_scene
      super
      mark('#prepare_scene: begin')
      
      # Glass Panel

      @glass = GlassPanel.new(600, 600)
      @glass.x = 550
      @glass.y = 60
      @glass_label = {x: 600, y: 685, text: "Glass Panel cuts: #{@glass.cuts}"}.merge(DEBUG_LABEL_COLOR)

      # Info Labels
      $gtk.args.outputs.static_labels << [
        @glass_label,
        {
          x:    600,
          y:    320,
          text: 'Test the TickTraceService (see console output)'
        }.merge(DEBUG_LABEL_COLOR)
      ]

      $gtk.args.outputs.static_sprites << [
        @glass
      ]

      mark('#prepare_scene: complete')
    end

    def unload_scene
    end

    def perform_tick
      mark('#perform_tick: begin')
      $gtk.args.outputs.background_color = [0, 0, 0, 0]

      update_glass_panel

      mark('#perform_tick: finished updates')

      finished = super

      mark('#perform_tick: finished super')
      return finished if finished
    end

    def update_glass_panel
      mark('#update_glass_panel: begin')
      cuts = ('%04b' % (($gtk.args.tick_count / 60) % 16)).chars.map { |bit| bit == '1' }
      @glass.change_cuts(cuts)
      @glass_label.text = "Glass panel cuts: #{@glass.cuts}"
      mark('#update_glass_panel: complete')
    end
  end
end
