class SpriteFont
  class Line
    attr :characters, :length, :offset

    def initialize
      @characters = []
      @length = 0
      @offset = 0
    end

    def add_character(char, x, y, char_width)
      @characters.push({
        char: char,
        x: x,
        y: y
      })
      @length += char_width
    end

    def add_spacing(spacing_width)
      @length += spacing_width
    end
  end

  def initialize(
    image,
    font_size,
    char_set,
    spacing_data,
    char_size,
    char_spacing,
    horizontal_alignment = :left,
    vertical_alignment = :bottom,
    color = :black
  )
    @image = image
    @font_size = font_size
    @char_set = char_set
    @spacing_data = spacing_data
    @char_size = char_size
    @char_spacing = char_spacing

    number_of_char_horizontally_in_image = (@image.width / @char_size.width).floor
    @char_set_data = {}
    @char_set.each_char.with_index do |char, index|
      coor_y_of_char_in_image = (index / number_of_char_horizontally_in_image).floor
      coor_x_of_char_in_image = index - (coor_y_of_char_in_image * number_of_char_horizontally_in_image)
      @char_set_data[char] = {
        tile_x: coor_x_of_char_in_image * @char_size.width,
        tile_y: coor_y_of_char_in_image * @char_size.height,
        width: nil,
        height: @char_size.height
      }
    end
    @spacing_data.each do |info|
      info[1].each_char do |char|
        @char_set_data[char].width = info[0]
      end
    end

    @color = { r: 255, g: 255, b: 255 } # Default
    if color == :black
      @color = { r: 0, g: 0, b: 0 }
    elsif color == :white
      @color = { r: 255, g: 255, b: 255 }
    end

    @horizontal_alignment = horizontal_alignment
    @vertical_alignment = vertical_alignment
    @text = ''
    @total_height = 0
    @data_to_render = []
  end

  def process_data_to_render
    @data_to_render.clear
    posx = 0
    line = 0
    # Line Count
    line_count = @text.count("\n") + 1
    posy = ((line_count - 1) - line) * @char_size.height

    # Process lines
    @data_to_render[line] = Line.new
    @text.each_char do |char|
      if char == "\n"
        @data_to_render[line].add_spacing(-@char_spacing) if @data_to_render[line].length.positive?

        line += 1
        posx = 0
        posy = ((line_count - 1) - line) * @char_size.height
        @data_to_render[line] = Line.new
      elsif @char_set.downcase.include? char.downcase
        @data_to_render[line].add_character char, posx, posy, @char_set_data[char].width
        @data_to_render[line].add_spacing @char_spacing
        posx += @char_set_data[char].width
        posx += @char_spacing
      end
    end
    # Remove last added char spacing if needed
    @data_to_render[line].add_spacing(-@char_spacing) if @data_to_render[line].length.positive?

    # Set total height
    @total_height = line_count * @char_size.height

    # Process alignment offset
    case @horizontal_alignment
    when :left
      @data_to_render.each do |line|
        line.offset = 0
      end
    when :center
      @data_to_render.each do |line|
        line.offset = line.length / 2 * -1
      end
    when :right
      @data_to_render.each do |line|
        line.offset = line.length * -1
      end
    end
  end

  def sprites_data(x, y, text)
    if text != @text
      @text = text
      process_data_to_render
    end

    case @vertical_alignment
    when :top
      y -= @total_height
    when :center
      y -= (@total_height / 2)
    when :bottom
      # Do nothing - Default
    end

    sprites_data_array = []
    @data_to_render.each do |line|
      # puts characters
      line.characters.each do |character|
        char = character.char
        char_x = character.x
        char_y = character.y
        sprites_data_array.append(
          {
            x: x + ((char_x + line.offset) * @font_size),
            y: y + (char_y * @font_size),
            w: @char_set_data[char].width * @font_size,
            h: @char_set_data[char].height * @font_size,
            path: @image[:path],
            tile_x: @char_set_data[char].tile_x,
            tile_y: @char_set_data[char].tile_y,
            tile_w: @char_set_data[char].width,
            tile_h: @char_set_data[char].height,
            r: @color.r,
            g: @color.g,
            b: @color.b,
            scale_quality_enum: 1
          }
        )
      end
    end
    sprites_data_array
  end
end

GTK.reset
