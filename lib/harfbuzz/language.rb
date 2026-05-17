module Harfbuzz

  class Language < FFI::Struct

    layout :code, :char

    def code
      self[:code]
    end

    def inspect
      "<#{self} code = %d>" % code
    end

  end

  typedef Language.by_ref, :hb_language_t

  attach_function :hb_language_get_default, [], :hb_language_t
  attach_function :hb_language_from_string, [:string, :int], :hb_language_t
  attach_function :hb_language_to_string, [:hb_language_t], :string
  attach_function :hb_language_matches, [:hb_language_t, :hb_language_t], :hb_bool_t

  def self.language_default
    Harfbuzz.hb_language_get_default
  end

  def self.language_from_string(string)
    Harfbuzz.hb_language_from_string(string, -1)
  end

  def self.language_to_string(language)
    Harfbuzz.hb_language_to_string(language)
  end


end