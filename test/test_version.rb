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

    # def test_version_atleast
    #   assert Harfbuzz.version_atleast(1, 0, 0)
    # end

  end

end