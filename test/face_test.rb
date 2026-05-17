require_relative 'helpers'

module Harfbuzz

  class TestFace < Minitest::Test

    include Setup

    def test_index
      assert { @face.index == 0 }
    end

    def test_upem
      assert { @face.upem > 0 }
    end

    def test_glyph_count
      assert { @face.glyph_count > 0 }
    end

    def test_names
      assert { @face.font_family_name == 'Adobe Caslon Pro' }
      assert { @face.font_subfamily_name == 'Regular' }
      assert { @face.postscript_name == 'ACaslonPro-Regular' }
    end

  end

end