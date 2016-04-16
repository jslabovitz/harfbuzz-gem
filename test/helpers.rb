require 'harfbuzz'
require 'minitest/autorun'

def load_face
  Harfbuzz::Face.new(File.open('/Library/Fonts/ACaslonPro-Regular.otf', 'rb'))
end

def load_font(face)
  Harfbuzz::Font.new(face)
end