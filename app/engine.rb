# Engine Methods

def reset_game
  $game = nil
  $gtk.reset
end

def keyboard
  $gtk.args.inputs.keyboard
end

def screenshots(args)
  return unless args.inputs.keyboard.key_up.single_quotation_mark

  args.outputs.screenshots << {
    x: 0, y: 0, w: 1280, h: 720, path: 'screenshot.png'

  }
end

# You can customize the buttons that show up in the Console.
class GTK::Console::Menu
  # STEP 1: Override the custom_buttons function.
  def custom_buttons
    [
      (button id: :reset_game,
              # row for button
              row: 3,
              # column for button
              col: 10,
              # text
              text: 'Reset $game',
              # when clicked call the custom_button_clicked function
              method: :reset_game_clicked)
    ]
  end

  # STEP 2: Define the function that should be called.
  def reset_game_clicked
    reset_game
  end
end
