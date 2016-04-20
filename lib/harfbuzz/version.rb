module Harfbuzz

  attach_function :hb_version_string, [], :string
  attach_function :hb_version, [:pointer, :pointer, :pointer], :void
  attach_function :hb_version_atleast, [:uint, :uint, :uint], :bool

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

  def self.version_at_least(major, minor, micro)
    Harfbuzz.hb_version_atleast(major, minor, micro)
  end

  MinimumHarfbuzzVersion = [1, 0, 4]

  unless version_at_least(*MinimumHarfbuzzVersion)
    raise "Harfbuzz C library is version #{Harfbuzz.version_string}, but this gem requires version #{MinimumHarfbuzzVersion.join('.')} or later"
  end

end