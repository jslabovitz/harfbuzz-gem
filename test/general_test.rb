require_relative 'helpers'

module Harfbuzz

  class TestGeneral < Minitest::Test

    include Setup

    def test_shapers
      shapers = Harfbuzz.shapers
      assert { shapers.kind_of?(Array) }
      assert { shapers.include?('fallback') }
    end

    def test_language_default
      assert { Harfbuzz.language_default.code == 101 }
    end

    def test_language_from_string
      assert { Harfbuzz.language_from_string('en').code == 101 }
    end

    def test_language_to_string
      en = Harfbuzz.language_from_string('en')
      assert { Harfbuzz.language_to_string(en) == 'en' }
    end

  end

end