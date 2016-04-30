require './test/helpers'

module Harfbuzz

  class TestShaper < Minitest::Test

    include Setup

    def test_shape
      buffer = Harfbuzz::Buffer.new
      buffer.add_utf8('fi')
      buffer.guess_segment_properties
      Harfbuzz.shape(@font, buffer, %w{+dlig +hlig})
      buffer.normalize_glyphs
      glyph_infos = buffer.get_glyph_infos
      glyph_positions = buffer.get_glyph_positions

      assert buffer.length == 1

      info, position = glyph_infos[0], glyph_positions[0]
      glyph_name = @font.glyph_to_string(info.codepoint)

      assert_equal 320, info.codepoint
      refute_equal 0, position.x_advance
      assert_equal 'f_i', glyph_name
    end

  end

end