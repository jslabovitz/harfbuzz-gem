require './test/helpers'

module Harfbuzz

  class TestGeneral < Minitest::Test

    include Setup

    def test_version
      version = Harfbuzz.version
      assert version.kind_of?(Array)
      assert version.each { |v| v === Numeric }
    end

    def test_version_string
      version = Harfbuzz.version_string
      assert version.kind_of?(String)
      assert version =~ /^\d+\.\d+/
    end

    def test_shapers
      shapers = Harfbuzz.shapers
      assert shapers.kind_of?(Array)
      assert shapers.include?('fallback')
    end

  end

end