require 'mkmf'

unless find_header('harfbuzz/hb.h')
  abort "harfbuzz is missing"
end

unless find_library('harfbuzz', 'hb_version')
  abort "harfbuzz is missing"
end

create_makefile('harfbuzz')