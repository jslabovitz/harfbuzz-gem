module Harfbuzz

  typedef :pointer, :hb_face_t

  attach_function :hb_face_create, [
    :hb_blob_t,         # blob
    :uint,              # index
  ], :hb_face_t
  attach_function :hb_face_get_index, [:hb_face_t], :uint
  attach_function :hb_face_get_upem, [:hb_face_t], :uint
  attach_function :hb_face_get_glyph_count, [:hb_face_t], :uint

  class Face < Base

    attr_reader :hb_face

    def initialize(input, face_index=0)
      blob = case input
      when IO
        Harfbuzz::Blob.new(input.read, :HB_MEMORY_MODE_READONLY)
      when Blob
        # use as-is
      when String
        Harfbuzz::Blob.new(input, :HB_MEMORY_MODE_READONLY)
      else
        raise "Unknown input type: #{input.class}"
      end
      @hb_face = Harfbuzz.hb_face_create(blob.hb_blob, face_index)
      define_finalizer(:hb_buffer_destroy, @hb_face)
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

  end

end