require 'harfbuzz'
require 'minitest/autorun'
require 'minitest/power_assert'

module Harfbuzz

  module Setup

    def setup
      @data = File.open('/Library/Fonts/ACaslonPro-Regular.otf', 'rb')
      @blob = Harfbuzz::Blob.new(@data)
      @face = Harfbuzz::Face.new(@blob)
      @font = Harfbuzz::Font.new(@face)
    end

  end

end