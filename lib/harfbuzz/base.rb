module Harfbuzz

  class Base

    def self.finalize(method, ptr)
      proc {
        Harfbuzz.send(method, ptr) if ptr
      }
    end

    def define_finalizer(method, ptr)
      ObjectSpace.define_finalizer(self, self.class.finalize(method, ptr))
    end

  end

end