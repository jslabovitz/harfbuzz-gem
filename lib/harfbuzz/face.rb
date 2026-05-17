module Harfbuzz

  typedef :pointer, :hb_face_t
  typedef :uint,    :hb_ot_name_id_t

  attach_function :hb_face_create, [
    :hb_blob_t,         # blob
    :uint,              # index
  ], :hb_face_t
  attach_function :hb_face_destroy, [:hb_face_t], :void
  attach_function :hb_face_get_index, [:hb_face_t], :uint
  attach_function :hb_face_get_upem, [:hb_face_t], :uint
  attach_function :hb_face_get_glyph_count, [:hb_face_t], :uint
  attach_function :hb_ot_name_get_utf8, [
    :hb_face_t,         # face
    :hb_ot_name_id_t,   # name_id
    :hb_language_t,     # language
    :pointer,           # text_size (uint *)
    :pointer,           # text (char *)
  ], :uint

  HB_OT_NAME_ID_COPYRIGHT   = 0
  HB_OT_NAME_ID_FONT_FAMILY   = 1
  HB_OT_NAME_ID_FONT_SUBFAMILY    = 2
  HB_OT_NAME_ID_UNIQUE_ID   = 3
  HB_OT_NAME_ID_FULL_NAME   = 4
  HB_OT_NAME_ID_VERSION_STRING    = 5
  HB_OT_NAME_ID_POSTSCRIPT_NAME   = 6
  HB_OT_NAME_ID_TRADEMARK   = 7
  HB_OT_NAME_ID_MANUFACTURER    = 8
  HB_OT_NAME_ID_DESIGNER    = 9
  HB_OT_NAME_ID_DESCRIPTION   = 10
  HB_OT_NAME_ID_VENDOR_URL    = 11
  HB_OT_NAME_ID_DESIGNER_URL    = 12
  HB_OT_NAME_ID_LICENSE     = 13
  HB_OT_NAME_ID_LICENSE_URL   = 14
  HB_OT_NAME_ID_TYPOGRAPHIC_FAMILY  = 16
  HB_OT_NAME_ID_TYPOGRAPHIC_SUBFAMILY = 17
  HB_OT_NAME_ID_MAC_FULL_NAME   = 18
  HB_OT_NAME_ID_SAMPLE_TEXT   = 19
  HB_OT_NAME_ID_CID_FINDFONT_NAME = 20
  HB_OT_NAME_ID_WWS_FAMILY    = 21
  HB_OT_NAME_ID_WWS_SUBFAMILY   = 22
  HB_OT_NAME_ID_LIGHT_BACKGROUND  = 23
  HB_OT_NAME_ID_DARK_BACKGROUND   = 24
  HB_OT_NAME_ID_VARIATIONS_PS_PREFIX  = 25

  class Face < Base

    attr_reader :hb_face

    def initialize(blob, face_index=0)
      blob = Blob.new(blob) unless blob.kind_of?(Blob)
      @hb_face = Harfbuzz.hb_face_create(blob.hb_blob, face_index)
      define_finalizer(:hb_face_destroy, @hb_face)
    end

    def index
      Harfbuzz.hb_face_get_index(@hb_face)
    end

    def upem
      Harfbuzz.hb_face_get_upem(@hb_face)
    end

    def glyph_count
      Harfbuzz.hb_face_get_glyph_count(@hb_face)
    end

    MAX_NAME_LEN = 200

    def name(name_id, language=nil)
      text_size_ptr = FFI::MemoryPointer.new(:uint, 1)
      text_size_ptr.write_uint(MAX_NAME_LEN)
      text_ptr = FFI::MemoryPointer.new(:char, MAX_NAME_LEN) #FIXME: ?
      #FIXME: check result
      Harfbuzz.hb_ot_name_get_utf8(@hb_face, name_id, language, text_size_ptr, text_ptr)
      text_ptr.get_string(0, MAX_NAME_LEN)
    end

    def font_family_name(language=nil)
      name(HB_OT_NAME_ID_FONT_FAMILY, language)
    end

    def font_subfamily_name(language=nil)
      name(HB_OT_NAME_ID_FONT_SUBFAMILY, language)
    end

    def full_name(language=nil)
      name(HB_OT_NAME_ID_FULL_NAME, language)
    end

    def postscript_name(language=nil)
      name(HB_OT_NAME_ID_POSTSCRIPT_NAME, language)
    end

  end

end