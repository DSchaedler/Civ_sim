SPRITE_WIDTH = 16
SPRITE_HEIGHT = 16

MARGIN = 1

SCREEN_WIDTH = 16
SCREEN_HEIGHT = 9

GRID_SIZE = 80

BASE_SPRITE = {
  w: GRID_SIZE,
  h: GRID_SIZE,
  path: 'app/sprites/roguelikeCity_transparent.png',
  source_w: SPRITE_WIDTH,
  source_h: SPRITE_HEIGHT
}.freeze

SPRITE_GRASS_A = {
  source_x: 1 * (SPRITE_WIDTH + MARGIN),
  source_y: 1 * (SPRITE_HEIGHT + MARGIN)
}.merge(BASE_SPRITE)

SPRITE_GRASS_B = {
  source_x: 0 * (SPRITE_WIDTH + MARGIN),
  source_y: 3 * (SPRITE_HEIGHT + MARGIN)
}.merge(BASE_SPRITE)

SPRITE_GRASS_C = {
  source_x: 1 * (SPRITE_WIDTH + MARGIN),
  source_y: 3 * (SPRITE_HEIGHT + MARGIN)
}.merge(BASE_SPRITE)
