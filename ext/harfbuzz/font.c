#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

VALUE cHarfbuzz_Font;

void
font_free(
  hb_font_t *hb_font
) {
  hb_font_destroy(hb_font);
}

VALUE
font_new(
  VALUE self,
  VALUE face
) {
  hb_face_t *hb_face = get_face(face);
  hb_font_t *hb_font = hb_font_create(hb_face);
  VALUE font = Data_Wrap_Struct(cHarfbuzz_Font, 0, font_free, hb_font);
  rb_obj_call_init(font, 0, 0);
  return font;
}

VALUE
font_scale(
  VALUE self
) {
  hb_font_t *hb_font = get_font(self);
  int x_scale, y_scale;
  hb_font_get_scale(hb_font, &x_scale, &y_scale);
  return rb_ary_new_from_args(2, INT2FIX(x_scale), INT2FIX(y_scale));
}

VALUE
font_ppem(
  VALUE self
) {
  hb_font_t *hb_font = get_font(self);
  unsigned int x_ppem, y_ppem;
  hb_font_get_ppem(hb_font, &x_ppem, &y_ppem);
  return rb_ary_new_from_args(2, INT2FIX(x_ppem), INT2FIX(y_ppem));
}

void
setup_harfbuzz_font(
  VALUE mHarfbuzz
) {
  cHarfbuzz_Font = rb_define_class_under(mHarfbuzz, "Font", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_Font, "new", font_new, 1);
  rb_define_method(cHarfbuzz_Font, "scale", font_scale, 0);
  rb_define_method(cHarfbuzz_Font, "ppem", font_ppem, 0);
}