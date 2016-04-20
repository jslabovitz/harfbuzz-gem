require './test/helpers'

module Harfbuzz

  class TestFace < Minitest::Test

    include Setup

    def test_index
      assert @face.index == 0
    end

    def test_upem
      assert @face.upem > 0
    end

    def test_glyph_count
      assert @face.glyph_count > 0
    end

  end

end