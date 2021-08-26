# Allows modifying controls
module Civ
  def input_up
    $gtk.args.inputs.keyboard.keys
  end
end

Civ.extend Civ
