module Civ
  # Abstracted drawing handler.
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
        args.outputs.static_primitives << @current_static
      end

    end
  end
end
