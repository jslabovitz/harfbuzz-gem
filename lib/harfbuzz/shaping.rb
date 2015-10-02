module Harfbuzz

  typedef :uint32, :hb_tag_t

  class Feature < FFI::Struct

    layout \
      :tag,   :hb_tag_t,
      :value, :uint32,
      :start, :uint,
      :end,   :uint

  end

  # typedef Feature, :hb_feature_t

  attach_function :hb_shape_list_shapers, [], :pointer
  attach_function :hb_shape, [
    :hb_font_t,     # font
    :hb_buffer_t,   # buffer
    :pointer,       # features
    :uint,          # num_features
  ], :void
  attach_function :hb_shape_full, [
    :hb_font_t,     # font
    :hb_buffer_t,   # buffer
    :pointer,       # features
    :uint,          # num_features
    :pointer,       # shaper_list
  ], :bool
  attach_function :hb_feature_from_string, [
    :pointer,       # str
    :int,           # len
    Feature.by_ref, # feature
  ], :bool
  attach_function :hb_feature_to_string, [
    Feature.by_ref, # feature
    :pointer,       # buf
    :uint,          # size,
  ], :void

  def self.shapers
    Harfbuzz.hb_shape_list_shapers.read_array_of_strings
  end

  def self.shape(font, buffer, features=nil, shapers=nil)
    features_ptr, features_len = features_from_strings(features)
    shapers_ptr = shapers ? FFI::MemoryPointer.from_array_of_strings(shapers) : nil
    Harfbuzz.hb_shape_full(
      font.hb_font,
      buffer.hb_buffer,
      features_ptr,
      features_len,
      shapers_ptr,
    )
  end

  def self.features_from_strings(feature_strings)
    features_len = feature_strings ? feature_strings.length : 0
    if features_len > 0
      features_ptr = FFI::MemoryPointer.new(Feature, features_len)
      feature_strings.each_with_index do |feature_string, i|
        feature_string_ptr = FFI::MemoryPointer.new(:char, feature_string.bytesize)
        feature_string_ptr.put_bytes(0, feature_string)
        feature_ptr = Feature.new(features_ptr + (i * Feature.size))
        hb_feature_from_string(feature_string_ptr, feature_string.bytesize, feature_ptr) \
          or raise "Can't get feature from string: #{feature_string.inspect}"
      end
    else
      features_ptr = nil
    end
    [features_ptr, features_len]
  end

end