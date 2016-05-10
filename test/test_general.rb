require_relative 'helpers'

module Harfbuzz

  class TestGeneral < Minitest::Test

    include Setup

    def test_shapers
      shapers = Harfbuzz.shapers
      assert { shapers.kind_of?(Array) }
      assert { shapers.include?('fallback') }
    end

  end

end