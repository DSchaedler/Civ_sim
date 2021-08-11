module Civ
  # Abstracted drawing handler.
  # Add primitives to $game.draw.draw or $game.draw.static_draw
  # e.g. $game.draw.static_draw << [100, 100, "Hello World"].label
  class Draw
    attr_accessor :draw, :static_draw

    def initialize
      @draw = []
      @static_draw = []
      @current_static = []
    end

    def tick(args)
      args.outputs.primitives << @draw if @draw
      @draw = []

      return unless @static_draw != @current_static

      @current_static = @static_draw
      args.outputs.static_primitives.clear
      args.outputs.static_primitives << @current_static
    end
  end
end
