require 'ffi'

require 'harfbuzz/ffi_additions'

module Harfbuzz

  extend FFI::Library

  ffi_lib 'harfbuzz'

  typedef :pointer, :hb_destroy_func_t
  typedef :uint32,  :hb_codepoint_t
  typedef :bool,    :hb_bool_t
  typedef :int32,   :hb_position_t

end

require 'harfbuzz/version'
require 'harfbuzz/base'
require 'harfbuzz/blob'
require 'harfbuzz/face'
require 'harfbuzz/font'
require 'harfbuzz/buffer'
require 'harfbuzz/shaping'