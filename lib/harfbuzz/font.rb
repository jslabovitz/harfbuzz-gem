module Harfbuzz

  typedef :pointer, :hb_font_t

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

  end

end