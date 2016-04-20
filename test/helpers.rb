$LOAD_PATH.unshift('lib')

require 'harfbuzz'
require 'minitest/autorun'

module Harfbuzz

  module Setup

    def setup
      @data = File.open('/Library/Fonts/ACaslonPro-Regular.otf', 'rb').read
      @blob = Harfbuzz::Blob.new(@data)
      @face = Harfbuzz::Face.new(@blob, 0)
      @font = Harfbuzz::Font.new(@face)
    end

  end

end