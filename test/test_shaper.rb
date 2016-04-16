require './test/helpers'

module Harfbuzz

  class TestShaper < Minitest::Test

    def setup
      @face = load_face
      @font = load_font(@face)
    end

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
      glyph_name = @font.glyph_to_string(info[:codepoint])

      assert info[:codepoint] == 320
      assert position[:x_advance] > 0
      assert glyph_name == 'f_i'
    end

  end

end