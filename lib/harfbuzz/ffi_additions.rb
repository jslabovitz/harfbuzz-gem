class FFI::Pointer

  # after https://dzone.com/articles/getting-array-strings-char-ffi

  def read_array_of_strings
    elements = []
    loc = self
    until (element = loc.read_pointer).null?
     elements << element.read_string
     loc += FFI::Type::POINTER.size
    end
    elements
  end

end

class FFI::MemoryPointer

  # after http://zegoggl.es/2009/05/ruby-ffi-recipes.html

  def self.from_array_of_strings(strings)
    string_ptrs = strings.map { |s| FFI::MemoryPointer.from_string(s) } + [nil]
    strings_ptr = new(:pointer, string_ptrs.length)
    string_ptrs.each_with_index do |ptr, i|
      strings_ptr[i].put_pointer(0, ptr)
    end
    strings_ptr
  end

end