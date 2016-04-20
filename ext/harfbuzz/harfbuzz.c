#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

#define REQUIRED_HB_VERSION_MAJOR 1
#define REQUIRED_HB_VERSION_MINOR 0
#define REQUIRED_HB_VERSION_MICRO 4

void setup_harfbuzz_blob(VALUE);
void setup_harfbuzz_buffer(VALUE);
void setup_harfbuzz_face(VALUE);
void setup_harfbuzz_font(VALUE);
void setup_harfbuzz_shape(VALUE);
void setup_harfbuzz_version(VALUE);

static void
check_version(void)
{
  if (!hb_version_atleast(REQUIRED_HB_VERSION_MAJOR, REQUIRED_HB_VERSION_MINOR, REQUIRED_HB_VERSION_MICRO)) {
    rb_fatal("Harfbuzz C library is version %s, but this gem requires version %d.%d.%d or later",
      hb_version_string(),
      REQUIRED_HB_VERSION_MAJOR,
      REQUIRED_HB_VERSION_MINOR,
      REQUIRED_HB_VERSION_MICRO
    );
  }
}

hb_glyph_info_t *
get_glyph_info(VALUE obj) {
  hb_glyph_info_t *hb_glyph_info;
  Data_Get_Struct(obj, hb_glyph_info_t, hb_glyph_info);
  return hb_glyph_info;
}

hb_glyph_position_t *
get_glyph_position(VALUE obj) {
  hb_glyph_position_t *hb_glyph_position;
  Data_Get_Struct(obj, hb_glyph_position_t, hb_glyph_position);
  return hb_glyph_position;
}

hb_buffer_t *
get_buffer(VALUE obj) {
  hb_buffer_t *hb_buffer;
  Data_Get_Struct(obj, hb_buffer_t, hb_buffer);
  return hb_buffer;
}

hb_blob_t *
get_blob(VALUE obj) {
  hb_blob_t *hb_blob;
  Data_Get_Struct(obj, hb_blob_t, hb_blob);
  return hb_blob;
}

hb_face_t *
get_face(VALUE obj) {
  hb_face_t *hb_face;
  Data_Get_Struct(obj, hb_face_t, hb_face);
  return hb_face;
}

hb_font_t *
get_font(VALUE obj) {
  hb_font_t *hb_font;
  Data_Get_Struct(obj, hb_font_t, hb_font);
  return hb_font;
}

void
Init_harfbuzz(void)
{
  check_version();
  VALUE mHarfbuzz = rb_define_module("Harfbuzz");
  setup_harfbuzz_blob(mHarfbuzz);
  setup_harfbuzz_buffer(mHarfbuzz);
  setup_harfbuzz_face(mHarfbuzz);
  setup_harfbuzz_font(mHarfbuzz);
  setup_harfbuzz_shape(mHarfbuzz);
  setup_harfbuzz_version(mHarfbuzz);
}