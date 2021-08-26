# Allows scenes to be referenced as Namespaced Methods
module Civ
  def scene_main
    $game.scene_manager.scenes[:main] ||= SceneMain.new
    $game.scene_manager.scenes[:main]
  end

  def scene_main_paint
    $game.scene_manager.scenes[:mainPaint] ||= SceneMainPaint.new
    $game.scene_manager.scenes[:mainPaint]
  end

  def scene_main_paint_pick
    $game.scene_manager.scenes[:mainPaintPick] ||= SceneMainPaintPick.new
    $game.scene_manager.scenes[:mainPaintPick]
  end
end

Civ.extend Civ
