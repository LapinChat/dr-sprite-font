require 'app/sprite_font'

LCW_SPRITE_FONT_DATA = {
  image: {
    path: 'sprites/spritefontwhite.png',
    width: 450,
    height: 780
  },
  char_set: "1234567890',!?.|$*#()[]/{}\":;%abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ- ",
  spacing_data: [
    [44, '#'],
    [43, 'T'],
    [41, 'W'],
    [39, '%'],
    [38, 'Q'],
    [36, 'MOZ'],
    [35, 'FG'],
    [34, 'N'],
    [33, 'BSY$*'],
    [32, 'wAEV-'],
    [31, 'aHUX'],
    [30, 'mzDP8?'],
    [29, 'CJ07'],
    [28, 'dgpqKLR'],
    [27, 'b69'],
    [26, 'cosv34|'],
    [25, 'ftu5'],
    [24, 'hery/'],
    [23, 'nkx2'],
    [21, 'j'],
    [18, '{}'],
    [16, '1'],
    [15, '()[]"'],
    [13, ' I,.:;'],
    [10, "il!'"]
  ],
  char_size: {
    width: 45,
    height: 78
  },
  char_spacing: 0
}

def tick(args)

  args.state.sprite_font ||= SpriteFont.new(
    LCW_SPRITE_FONT_DATA.image,
    3.1,
    LCW_SPRITE_FONT_DATA.char_set,
    LCW_SPRITE_FONT_DATA.spacing_data,
    LCW_SPRITE_FONT_DATA.char_size,
    LCW_SPRITE_FONT_DATA.char_spacing,
    :center,
    :center,
    :white
  )

  args.outputs.background_color = [0, 0, 0]
  args.outputs.sprites << args.state.sprite_font.sprites_data(
    Grid.w / 2, 190,
    "Hello\nWorld"
  )
end

$gtk.reset