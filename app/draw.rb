module Civ
  # Abstracted drawing handler.
  # Add primitives to $game.draw.draw or $game.draw.static_draw
  # e.g. $game.draw.static_draw << [100, 100, "Hello World"].label
  class Draw
    attr_accessor :layers, :static_draw

    def initialize(_args)
      # layers = [[{}, {}, {},], [{}, {}, {}]]
      @layers = []
      @static_draw = []
      @current_static = []
    end

    def tick(args)
      if @static_draw != @current_static
        @current_static = @static_draw
        args.outputs.static_primitives.clear
        args.outputs.static_primitives << @current_static
      end

      @layers.each do |layer|
        args.outputs.primitives << layer
      end
      @layers.clear
    end
  end
end
