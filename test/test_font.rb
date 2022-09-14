require_relative 'helpers'

module Harfbuzz

  class TestFont < Minitest::Test

    include Setup

    def test_init_with_size
      font2 = Harfbuzz::Font.new(@face, 12)
      assert { font2.ptem == 12.0 }
    end

    def test_scale
      scale = @font.scale
      assert { scale.kind_of?(Array) }
      assert { scale.each { |v| v === Numeric && v > 0 } }
    end

    def test_ppem
      ppem = @font.ppem
      assert { ppem.kind_of?(Array) }
      assert { ppem.each { |v| v === Numeric && v > 0 } }
    end

    def test_glyph_name
      glyph_name = 'A'
      glyph = @font.glyph_from_name(glyph_name)
      refute { glyph.nil? }
      name = @font.glyph_name(glyph)
      assert { name == glyph_name }
    end

    def test_extents
      h_extents, v_extents = @font.extents
      assert { h_extents.ascender > 0 }
      assert { v_extents.ascender == 0 }
    end

    def test_glyph_extents
      extents = @font.glyph_extents(1)
      assert { extents.width != 0 }
      assert { extents.height != 0 }
    end

    def test_glyph_advance
      advance = @font.glyph_advance_for_direction(1, Harfbuzz::HB_DIRECTION_LTR)
      assert { advance > 0 }
    end

  end

end