module Harfbuzz

  typedef :pointer, :hb_font_t

  class GlyphExtents < FFI::Struct
    layout \
      :x_bearing,  :hb_position_t,
      :y_bearing,  :hb_position_t,
      :width,      :hb_position_t,
      :height,     :hb_position_t

    def x_bearing
      self[:x_bearing]
    end

    def y_bearing
      self[:y_bearing]
    end

    def width
      self[:width]
    end

    def height
      self[:height]
    end
  end

  if at_least_version(1,1,3)
    class FontExtents < FFI::Struct
      layout \
        :ascender,   :hb_position_t,
        :descender,  :hb_position_t,
        :line_gap,   :hb_position_t,
        :reserved9,  :hb_position_t, #private
        :reserved8,  :hb_position_t, #private
        :reserved7,  :hb_position_t, #private
        :reserved6,  :hb_position_t, #private
        :reserved5,  :hb_position_t, #private
        :reserved4,  :hb_position_t, #private
        :reserved3,  :hb_position_t, #private
        :reserved2,  :hb_position_t, #private
        :reserved1,  :hb_position_t #private

      def inspect
        "Ascender: #{ascender}\nDescender: #{descender}\nLine Gap: #{line_gap}"
      end

      def ascender
        self[:ascender]
      end

      def descender
        self[:descender]
      end

      def line_gap
        self[:line_gap]
      end
    end

    attach_function :hb_font_get_h_extents, [
      :hb_font_t,         #font
      FontExtents.by_ref  #extents
    ], :hb_bool_t
    attach_function :hb_font_get_v_extents, [
      :hb_font_t,         #font
      FontExtents.by_ref  #extents
    ], :hb_bool_t
  end

  attach_function :hb_font_create, [:hb_face_t], :hb_font_t
  attach_function :hb_font_set_scale, [
    :hb_font_t,     # font
    :int,           # x_scale
    :int,           # y_scale
  ], :void
  attach_function :hb_ft_font_set_funcs, [:hb_font_t], :void
  attach_function :hb_font_get_scale, [
    :hb_font_t,     # font
    :pointer,       # int *x_scale
    :pointer,       # int *y_scale
  ], :void
  attach_function :hb_font_get_ppem, [
    :hb_font_t,     # font
    :pointer,       # unsigned int *x_ppem
    :pointer,       # unsigned int *y_ppem
  ], :void
  attach_function :hb_font_glyph_to_string, [
    :hb_font_t,     # font
    :hb_codepoint_t, # glyph
    :pointer,       # string
    :uint,          # size
  ], :void
  attach_function :hb_font_get_glyph_extents, [
    :hb_font_t,          #font
    :hb_codepoint_t,     #glyph
    GlyphExtents.by_ref  #extents
  ], :hb_bool_t

  class Font < Base

    attr_reader :hb_font

    def initialize(face)
      @hb_font = Harfbuzz.hb_font_create(face.hb_face)
      Harfbuzz.hb_font_set_scale(@hb_font, face.upem, face.upem)
      Harfbuzz.hb_ft_font_set_funcs(@hb_font)
      define_finalizer(:hb_font_destroy, @hb_font)
    end

    def scale
      x_scale_ptr = FFI::MemoryPointer.new(:int, 1)
      y_scale_ptr = FFI::MemoryPointer.new(:int, 1)
      Harfbuzz.hb_font_get_scale(@hb_font, x_scale_ptr, y_scale_ptr)
      [
        x_scale_ptr.read_int,
        y_scale_ptr.read_int,
      ]
    end

    def ppem
      ppem_x_ptr = FFI::MemoryPointer.new(:uint, 1)
      ppem_y_ptr = FFI::MemoryPointer.new(:uint, 1)
      Harfbuzz.hb_font_get_ppem(@hb_font, ppem_x_ptr, ppem_y_ptr)
      [
        ppem_x_ptr.read_uint,
        ppem_y_ptr.read_uint,
      ]
    end

    def glyph_to_string(glyph)
      string_ptr = FFI::MemoryPointer.new(:char, 20)
      Harfbuzz.hb_font_glyph_to_string(@hb_font, glyph, string_ptr, 20)
      string_ptr.get_string(0, 20)
    end

    def glyph_extents(codepoint)
      glyph_extents = GlyphExtents.new
      Harfbuzz.hb_font_get_glyph_extents(@hb_font, codepoint, glyph_extents)
      glyph_extents
    end

    if Harfbuzz.at_least_version(1,1,3)
      def h_extents
        extents_for_direction(:h)
      end

      def v_extents
        extents_for_direction(:v)
      end

      def extents
        [h_extents, v_extents]
      end

      def extents_for_direction(direction)
        extents = FontExtents.new
        func = "hb_font_get_#{direction}_extents".to_sym
        Harfbuzz.send(func, @hb_font, extents)
        extents
      end
    end
  end

end
