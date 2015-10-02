module Harfbuzz

  class Base

    def self.finalize(method, ptr)
      proc {
        Harfbuzz.send(method, ptr) unless ptr == 0
      }
    end

    def define_finalizer(method, ptr)
      ObjectSpace.define_finalizer(self, self.class.finalize(method, ptr))
    end

  end

end