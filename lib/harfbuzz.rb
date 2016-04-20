require 'ffi'

require 'harfbuzz/ffi_additions'

module Harfbuzz

  extend FFI::Library

  ffi_lib 'harfbuzz'

  typedef :pointer, :hb_destroy_func_t
  typedef :uint32, :hb_codepoint_t

  attach_function :hb_version_string, [], :string
  attach_function :hb_version, [:pointer, :pointer, :pointer], :void

  def self.version_string
    hb_version_string
  end

  def self.version
    major_ptr = FFI::MemoryPointer.new(:uint, 1)
    minor_ptr = FFI::MemoryPointer.new(:uint, 1)
    micro_ptr = FFI::MemoryPointer.new(:uint, 1)
    hb_version(major_ptr, minor_ptr, micro_ptr)
    [
      major_ptr.read_uint,
      minor_ptr.read_uint,
      micro_ptr.read_uint,
    ]
  end

  MinimumHarfbuzzVersion = '1.0.4'

  unless Gem::Version.new(Harfbuzz.version_string) >= Gem::Version.new(MinimumHarfbuzzVersion)
    raise "Harfbuzz C library is version #{Harfbuzz.version_string}, but this gem requires version #{MinimumHarfbuzzVersion} or later"
  end

end

require 'harfbuzz/base'
require 'harfbuzz/blob'
require 'harfbuzz/face'
require 'harfbuzz/font'
require 'harfbuzz/buffer'
require 'harfbuzz/shaping'