#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

VALUE cHarfbuzz_Buffer;
VALUE cHarfbuzz_GlyphInfo;
VALUE cHarfbuzz_GlyphPosition;

// GlyphInfo

VALUE
glyph_info_codepoint(
  VALUE self
) {
  hb_glyph_info_t *glyph_info = get_glyph_info(self);
  return INT2FIX(glyph_info->codepoint);
}

VALUE
glyph_info_mask(
  VALUE self
) {
  hb_glyph_info_t *glyph_info = get_glyph_info(self);
  return INT2FIX(glyph_info->mask);
}

VALUE
glyph_info_cluster(
  VALUE self
) {
  hb_glyph_info_t *glyph_info = get_glyph_info(self);
  return INT2FIX(glyph_info->cluster);
}

VALUE
glyph_info_new_from_hb_glyph_info_t(
  hb_glyph_info_t *hb_glyph_info
) {
  VALUE glyph_info = Data_Wrap_Struct(cHarfbuzz_GlyphInfo, 0, NULL, hb_glyph_info);
  rb_obj_call_init(glyph_info, 0, 0);
  return glyph_info;
}

// Position

VALUE
glyph_position_x_advance(
  VALUE self
) {
  hb_glyph_position_t *glyph_position = get_glyph_position(self);
  return INT2FIX(glyph_position->x_advance);
}

VALUE
glyph_position_y_advance(
  VALUE self
) {
  hb_glyph_position_t *glyph_position = get_glyph_position(self);
  return INT2FIX(glyph_position->y_advance);
}

VALUE
glyph_position_x_offset(
  VALUE self
) {
  hb_glyph_position_t *glyph_position = get_glyph_position(self);
  return INT2FIX(glyph_position->x_offset);
}

VALUE
glyph_position_y_offset(
  VALUE self
) {
  hb_glyph_position_t *glyph_position = get_glyph_position(self);
  return INT2FIX(glyph_position->y_offset);
}

VALUE
glyph_position_new_from_hb_glyph_position_t(
  hb_glyph_position_t *hb_glyph_position
) {
  VALUE glyph_position = Data_Wrap_Struct(cHarfbuzz_GlyphPosition, 0, NULL, hb_glyph_position);
  rb_obj_call_init(glyph_position, 0, 0);
  return glyph_position;
}

// Buffer

void
buffer_free(
  hb_buffer_t *hb_buffer
) {
  hb_buffer_destroy(hb_buffer);
}

VALUE
buffer_new(
  VALUE self
) {
  hb_buffer_t *hb_buffer = hb_buffer_create();
  VALUE buffer = Data_Wrap_Struct(cHarfbuzz_Buffer, 0, buffer_free, hb_buffer);
  rb_obj_call_init(buffer, 0, 0);
  return buffer;
}

VALUE
buffer_guess_segment_properties(
  VALUE self
) {
  hb_buffer_t *hb_buffer = get_buffer(self);
  hb_buffer_guess_segment_properties(hb_buffer);
  return Qnil;
}

VALUE
buffer_add_utf8(
  VALUE self,
  VALUE text
) {
  hb_buffer_t *hb_buffer = get_buffer(self);
  hb_buffer_add_utf8(
    hb_buffer,
    RSTRING_PTR(text),
    (int)RSTRING_LEN(text),
    0,  // FIXME: allow specification
    -1);  // FIXME: allow specification
  return Qnil;
}

VALUE
buffer_get_length(
  VALUE self
) {
  hb_buffer_t *hb_buffer = get_buffer(self);
  return INT2FIX(hb_buffer_get_length(hb_buffer));
}

VALUE
buffer_get_glyph_infos(
  VALUE self
) {
  unsigned int length;
  hb_glyph_info_t *glyph_infos = hb_buffer_get_glyph_infos(get_buffer(self), &length);
  VALUE ary = rb_ary_new();
  while (length > 0) {
    VALUE glyph_info = glyph_info_new_from_hb_glyph_info_t(glyph_infos);
    rb_ary_push(ary, glyph_info);
    length--, glyph_infos++;
  }
  return ary;
}

VALUE
buffer_get_glyph_positions(
  VALUE self
) {
  unsigned int length;
  hb_glyph_position_t *glyph_positions = hb_buffer_get_glyph_positions(get_buffer(self), &length);
  VALUE ary = rb_ary_new();
  while (length > 0) {
    VALUE glyph_position = glyph_position_new_from_hb_glyph_position_t(glyph_positions);
    rb_ary_push(ary, glyph_position);
    length--, glyph_positions++;
  }
  return ary;
}

VALUE
buffer_normalize_glyphs(
  VALUE self
) {
  hb_buffer_t *hb_buffer = get_buffer(self);
  hb_buffer_normalize_glyphs(hb_buffer);
  return Qnil;
}

void
setup_harfbuzz_buffer(
  VALUE mHarfbuzz
) {
  cHarfbuzz_GlyphInfo = rb_define_class_under(mHarfbuzz, "GlyphInfo", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_GlyphInfo, "new_from_hb_glyph_info_t", glyph_info_new_from_hb_glyph_info_t, 1);
  rb_define_method(cHarfbuzz_GlyphInfo, "codepoint", glyph_info_codepoint, 0);
  rb_define_method(cHarfbuzz_GlyphInfo, "mask", glyph_info_mask, 0);
  rb_define_method(cHarfbuzz_GlyphInfo, "cluster", glyph_info_cluster, 0);

  cHarfbuzz_GlyphPosition = rb_define_class_under(mHarfbuzz, "GlyphPosition", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_GlyphPosition, "new_from_hb_glyph_position_t", glyph_position_new_from_hb_glyph_position_t, 1);
  rb_define_method(cHarfbuzz_GlyphPosition, "x_advance", glyph_position_x_advance, 0);
  rb_define_method(cHarfbuzz_GlyphPosition, "y_advance", glyph_position_y_advance, 0);
  rb_define_method(cHarfbuzz_GlyphPosition, "x_offset", glyph_position_x_offset, 0);
  rb_define_method(cHarfbuzz_GlyphPosition, "y_offset", glyph_position_y_offset, 0);

  cHarfbuzz_Buffer = rb_define_class_under(mHarfbuzz, "Buffer", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_Buffer, "new", buffer_new, 0);
  rb_define_method(cHarfbuzz_Buffer, "guess_segment_properties", buffer_guess_segment_properties, 0);
  rb_define_method(cHarfbuzz_Buffer, "add_utf8", buffer_add_utf8, 1);
  rb_define_method(cHarfbuzz_Buffer, "length", buffer_get_length, 0);
  rb_define_method(cHarfbuzz_Buffer, "get_glyph_infos", buffer_get_glyph_infos, 0);
  rb_define_method(cHarfbuzz_Buffer, "get_glyph_positions", buffer_get_glyph_infos, 0);
  rb_define_method(cHarfbuzz_Buffer, "normalize_glyphs", buffer_normalize_glyphs, 0);
}