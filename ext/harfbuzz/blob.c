#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

VALUE cHarfbuzz_Blob;

void
blob_free(
  hb_blob_t *hb_blob
) {
  hb_blob_destroy(hb_blob);
}

VALUE
blob_new(
  VALUE self,
  VALUE data
) {
  Check_Type(data, T_STRING);
  hb_blob_t *hb_blob = hb_blob_create(
    RSTRING_PTR(data),
    (int)RSTRING_LEN(data),
    HB_MEMORY_MODE_READONLY,
    NULL,
    NULL);
  VALUE blob = Data_Wrap_Struct(cHarfbuzz_Blob, 0, blob_free, hb_blob);
  rb_obj_call_init(blob, 0, 0);
  return blob;
}

VALUE
blob_length(
  VALUE self
) {
  hb_blob_t *hb_blob = get_blob(self);
  return INT2FIX(hb_blob_get_length(hb_blob));
}

void
setup_harfbuzz_blob(
  VALUE mHarfbuzz
) {
  cHarfbuzz_Blob = rb_define_class_under(mHarfbuzz, "Blob", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_Blob, "new", blob_new, 1);
  rb_define_method(cHarfbuzz_Blob, "length", blob_length, 0);
}