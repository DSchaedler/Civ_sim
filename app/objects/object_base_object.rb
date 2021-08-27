module Civ
  class Object_Base_Object
    attr_accessor :id

    def initialize
      @id = rand(36**8).to_s(36)
    end
  end
end

Civ.extend Civ
