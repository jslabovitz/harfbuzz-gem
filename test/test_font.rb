require './test/helpers'

module Harfbuzz

  class TestFont < Minitest::Test

    include Setup

    def test_scale
      scale = @font.scale
      assert scale.kind_of?(Array)
      assert scale.each { |v| v === Numeric && v > 0 }
    end

    def test_ppem
      ppem = @font.ppem
      assert ppem.kind_of?(Array)
      assert ppem.each { |v| v === Numeric && v > 0 }
    end

    def test_glyph_name
      glyph_name = 'A'
      glyph = @font.glyph_from_name(glyph_name)
      refute_nil glyph
      name = @font.glyph_name(glyph)
      assert glyph_name, name
    end

    def test_extents
      h_extents, v_extents = @font.extents
      assert h_extents.ascender > 0
      assert v_extents.ascender == 0
    end

    def test_glyph_extents
      extents = @font.glyph_extents(1)
      assert extents.width != 0
      assert extents.height != 0
    end

  end

end