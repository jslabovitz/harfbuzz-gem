#!/usr/bin/env ruby

$LOAD_PATH.unshift 'lib'
require 'harfbuzz'

#
# Show some information about Harfbuzz
#

puts "Harfbuzz version: #{Harfbuzz.version_string}"
puts "Shapers: #{Harfbuzz.shapers.join(', ')}"

#
# Create a font to be used for shaping. To get the most of out this example, use an OpenType font.
#

face = Harfbuzz::Face.new(File.open('/Library/Fonts/ACaslonPro-Regular.otf', 'rb'))
font = Harfbuzz::Font.new(face)

#
# Create a buffer to hold the text and the resulting glyphs/positions.
#

buffer = Harfbuzz::Buffer.new

#
# Add some text to the buffer.
#

buffer.add_utf8('WAVE first.')

#
# Guess direction, script, & language from the text.
#

if true
  buffer.guess_segment_properties
else
  #FIXME: these functions are not yet bound
  # hb_buffer_set_direction(buffer, hb_direction_from_string(direction, -1))
  # hb_buffer_set_script(buffer, hb_script_from_string(script, -1))
  # hb_buffer_set_language(buffer, hb_language_from_string(language, -1))
  # hb_buffer_set_flags(buffer, shape_flags)
end

#
# Shape the text in the buffer using some interesting features.
#

Harfbuzz.shape(font, buffer, %w{+dlig +hlig})

#
# Normalize glyph clusters (FIXME: why?).
#

buffer.normalize_glyphs

#
# Iterate through the buffer, examining the glyphs & related positions.
#

glyph_infos = buffer.get_glyph_infos
glyph_positions = buffer.get_glyph_positions
buffer.length.times do |i|
  info, position = glyph_infos[i], glyph_positions[i]
  glyph_name = font.glyph_to_string(info[:codepoint])
  puts "/%-10.10s %5u | mask: %04X | cluster: %2u | advance: %4u,%4u | offset: %4u,%4u" % [
    glyph_name,
    info[:codepoint],
    info[:mask],
    info[:cluster],
    position[:x_advance], position[:y_advance],
    position[:x_offset], position[:y_offset],
  ]
end