module Harfbuzz

  typedef :pointer, :hb_blob_t

  enum :hb_memory_mode_t, [
    :HB_MEMORY_MODE_DUPLICATE,
    :HB_MEMORY_MODE_READONLY,
    :HB_MEMORY_MODE_WRITABLE,
    :HB_MEMORY_MODE_READONLY_MAY_MAKE_WRITABLE,
  ]

  attach_function :hb_blob_create, [
    :pointer,           # data
    :uint,              # length
    :hb_memory_mode_t,  # mode,
    :pointer,           # user_data,
    :hb_destroy_func_t, # destroy
  ], :hb_blob_t
  attach_function :hb_blob_get_length, [
    :hb_blob_t,         # blob
  ], :uint
  attach_function :hb_blob_destroy, [:hb_blob_t], :void

  class Blob < Base

    attr_reader :hb_blob

    def initialize(input, mode=0, user_data=nil)
      data = data.read if data.kind_of?(IO)
      data_ptr = FFI::MemoryPointer.new(:char, data.size)
      data_ptr.put_bytes(0, data)
      @hb_blob = Harfbuzz.hb_blob_create(data_ptr, data.size, mode, user_data, nil)
      define_finalizer(:hb_blob_destroy, @hb_blob)
    end

    def length
      Harfbuzz.hb_blob_get_length(@hb_blob)
    end

  end

end