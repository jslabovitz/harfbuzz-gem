require 'ffi'

require 'harfbuzz/ffi_additions'

module Harfbuzz

  extend FFI::Library

  ffi_lib 'harfbuzz'

  typedef :pointer, :hb_destroy_func_t
  typedef :uint32,  :hb_codepoint_t
  typedef :bool,    :hb_bool_t
  typedef :int32,   :hb_position_t

  # hb_direction_t enum
  HB_DIRECTION_INVALID = 0
  HB_DIRECTION_LTR = 4
  HB_DIRECTION_RTL = 5
  HB_DIRECTION_TTB = 6
  HB_DIRECTION_BTT = 7

  def self.hb_direction_is_valid(dir)
    dir & ~3 == 4
  end

  def self.hb_direction_is_horizontal(dir)
    dir & ~1 == 4
  end

  def self.hb_direction_is_vertical(dir)
    dir & ~1 == 6
  end

  def self.hb_direction_is_forward(dir)
    dir & ~2 == 4
  end

  def self.hb_direction_is_backward(dir)
    dir & ~2 == 5
  end

  def self.hb_direction_reverse(dir)
    dir ^ 1
  end

end

require 'harfbuzz/version'
require 'harfbuzz/base'
require 'harfbuzz/blob'
require 'harfbuzz/face'
require 'harfbuzz/font'
require 'harfbuzz/buffer'
require 'harfbuzz/shaping'