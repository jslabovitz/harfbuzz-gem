#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

static VALUE
version_string(
  VALUE self
) {
  return rb_str_new_cstr(hb_version_string());
}

static VALUE
version(
  VALUE self
) {
  unsigned int major, minor, micro;
  hb_version(&major, &minor, &micro);
  return rb_ary_new_from_args(3, INT2FIX(major), INT2FIX(minor), INT2FIX(micro));
}

static VALUE
version_atleast(
  VALUE self,
  unsigned int major,
  unsigned int minor,
  unsigned int micro
) {
  return hb_version_atleast(FIX2INT(major), FIX2INT(minor), FIX2INT(micro)) ? Qtrue : Qfalse;
}

void
setup_harfbuzz_version(
  VALUE mHarfbuzz
) {
  rb_define_singleton_method(mHarfbuzz, "version_string", version_string, 0);
  rb_define_singleton_method(mHarfbuzz, "version", version, 0);
  rb_define_singleton_method(mHarfbuzz, "version_atleast", version_atleast, 3);
}