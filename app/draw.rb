module Civ
  # Abstracted drawing handler.
  # Add primitives to $game.draw.draw or $game.draw.static_draw
  # e.g. $game.draw.static_draw << [100, 100, "Hello World"].label
  class Draw
    attr_accessor :layers, :static_layer

    def initialize(_args)
      # layers = [[{}, {}, {},], [{}, {}, {}]]
      @layers = []
      @static_layer = []
      @current_static = []
    end

    def tick(args)
      @layers.each do |layer|
        args.outputs.primitives << layer
      end
      @layers.clear
      
      if @static_layer != @current_static
        @current_static = @static_layer

        args.outputs.static_primitives.clear
        @current_static.each do |layer|
          args.outputs.static_primitives << layer
        end
      end

    end
  end
end
