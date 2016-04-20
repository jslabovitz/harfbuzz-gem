$LOAD_PATH.unshift('lib')

require 'benchmark'
require 'harfbuzz'

Words = File.read('examples/words.txt').split(/\s+/)
Features = %w{+dlig +hlig}

Benchmark.bm do |benchmark|
  benchmark.report do
    face = Harfbuzz::Face.new(Harfbuzz::Blob.new(File.open('/Library/Fonts/ACaslonPro-Regular.otf', 'rb')))
    font = Harfbuzz::Font.new(face)
    Words.each do |word|
      buffer = Harfbuzz::Buffer.new
      buffer.add_utf8(word)
      buffer.guess_segment_properties
      Harfbuzz.shape(font, buffer, Features)
      buffer.normalize_glyphs
    end
  end
end