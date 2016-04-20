module Harfbuzz

  typedef :pointer, :hb_buffer_t
  typedef :uint32, :hb_mask_t
  typedef :int32, :hb_position_t

  class GlyphInfo < FFI::Struct

    layout \
      :codepoint, :hb_codepoint_t,
      :mask,      :hb_mask_t,
      :cluster,   :uint32,
      :var1,      :uint32,  # private
      :var2,      :uint32   # private

    def codepoint
      self[:codepoint]
    end

    def mask
      self[:mask]
    end

    def cluster
      self[:cluster]
    end

  end

  class GlyphPosition < FFI::Struct

    layout \
      :x_advance, :hb_position_t,
      :y_advance, :hb_position_t,
      :x_offset,  :hb_position_t,
      :y_offset,  :hb_position_t,
      :var,       :uint32  # private

    def inspect
      "<#{self} %s>" % [
        %w{x_advance y_advance x_offset y_offset}.map { |k|
          "#{k} = #{self[k.to_sym].inspect}"
        }.join(', ')
      ]
    end

    def x_advance
      self[:x_advance]
    end

    def y_advance
      self[:y_advance]
    end

    def x_offset
      self[:x_offset]
    end

    def y_offset
      self[:y_offset]
    end

  end

  attach_function :hb_buffer_create, [], :hb_buffer_t
  attach_function :hb_buffer_add_utf8, [
    :hb_buffer_t,   # buffer
    :pointer,       # text
    :int,           # text_length
    :uint,          # item_offset
    :int,           # item_length
  ], :void
  attach_function :hb_buffer_guess_segment_properties, [:hb_buffer_t], :void
  attach_function :hb_buffer_get_length, [:hb_buffer_t], :uint
  attach_function :hb_buffer_get_glyph_infos, [
    :hb_buffer_t,   # buffer
    :pointer,       # length
  ], GlyphInfo
  attach_function :hb_buffer_get_glyph_positions, [
    :hb_buffer_t,   # buffer
    :pointer,       # length
  ], GlyphPosition
  attach_function :hb_buffer_normalize_glyphs, [:hb_buffer_t], :void

  class Buffer < Base

    attr_reader :hb_buffer

    def initialize
      @hb_buffer = Harfbuzz.hb_buffer_create
      define_finalizer(:hb_buffer_destroy, @hb_buffer)
    end

    def add_utf8(text, offset=0, length=-1)
      text_ptr = FFI::MemoryPointer.new(:char, text.bytesize)
      text_ptr.put_bytes(0, text)
      Harfbuzz.hb_buffer_add_utf8(@hb_buffer, text_ptr, text.bytesize, offset, length)
    end

    def guess_segment_properties
      Harfbuzz.hb_buffer_guess_segment_properties(@hb_buffer)
    end

    def normalize_glyphs
      Harfbuzz.hb_buffer_normalize_glyphs(@hb_buffer)
    end

    def length
      Harfbuzz.hb_buffer_get_length(@hb_buffer)
    end

    def get_glyph_infos
      length_ptr = FFI::MemoryPointer.new(:uint, 1)
      info_ptr = Harfbuzz.hb_buffer_get_glyph_infos(@hb_buffer, length_ptr)
      length = length_ptr.read_uint
      length.times.map do |i|
        GlyphInfo.new(info_ptr + (i * GlyphInfo.size))
      end
    end

    def get_glyph_positions
      length_ptr = FFI::MemoryPointer.new(:uint, 1)
      positions_ptr = Harfbuzz.hb_buffer_get_glyph_positions(@hb_buffer, length_ptr)
      length = length_ptr.read_uint
      length.times.map do |i|
        GlyphPosition.new(positions_ptr + (i * GlyphPosition.size))
      end
    end

  end
end