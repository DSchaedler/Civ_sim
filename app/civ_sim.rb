module Civ_Sim
  class Civ_Game < Zif::Game
    def initialize
      super()
      @services[:tracer].measure_averages = true
    end
  end
end
