require './test/helpers'

module Harfbuzz

  class TestBlob < Minitest::Test

    include Setup

    def test_length
      assert { @blob.length > 0 }
    end

  end

end