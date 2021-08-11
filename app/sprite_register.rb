SHEET_COLUMNS = 20
SHEET_ROWS = 13

SPRITE_WIDTH = 128
SPRITE_HEIGHT = 128

SCREEN_WIDTH = 16
SCREEN_HEIGHT = 9

BASE_SPRITE = {
  w: 80,
  h: 80,
  path: 'app/sprites/RPGpack_sheet_2X.png',
  source_w: SPRITE_WIDTH,
  source_h: SPRITE_HEIGHT
}.freeze

SPRITE_GRASS_A = {
  source_x: 1 * SPRITE_WIDTH,
  source_y: 11 * SPRITE_HEIGHT
}.merge(BASE_SPRITE)

SPRITE_GRASS_B = {
  source_x: 3 * SPRITE_WIDTH,
  source_y: 10 * SPRITE_WIDTH
}.merge(BASE_SPRITE)

SPRITE_GRASS_C = {
  source_x: 4 * SPRITE_WIDTH,
  source_y: 10 * SPRITE_WIDTH
}.merge(BASE_SPRITE)
