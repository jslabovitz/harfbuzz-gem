#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

/*
  typedef struct hb_feature_t {
    hb_tag_t      tag;
    uint32_t      value;
    unsigned int  start;
    unsigned int  end;
  } hb_feature_t;
*/

/*
  HB_EXTERN hb_bool_t
  hb_feature_from_string (const char *str, int len,
        hb_feature_t *feature);
*/

/*
  HB_EXTERN void
  hb_feature_to_string (hb_feature_t *feature,
            char *buf, unsigned int size);
*/

/*
  HB_EXTERN void
  hb_shape (hb_font_t           *font,
      hb_buffer_t         *buffer,
      const hb_feature_t  *features,
      unsigned int         num_features);
*/

VALUE
shape_shape(
  VALUE self,
  VALUE font,
  VALUE buffer,
  VALUE feature_strings
) {
  VALUE features = rb_ary_new();
  int i;
  for (i = 0; i < RARRAY_LEN(feature_strings); i++) {
    VALUE feature_string = rb_ary_entry(feature_strings, i);
    hb_feature_t feature;
    hb_feature_from_string(RSTRING_PTR(feature_string), (int)RSTRING_LEN(feature_string), &feature);
    rb_ary_push(features, new_from_hb_feature(feature));
  }
  hb_shape(get_font(font),
      get_buffer(buffer),
      (const hb_feature_t *)RARRAY_PTR(features),
      (unsigned int)RARRAY_LEN(features));
  return Qnil;
}

/*
  HB_EXTERN hb_bool_t
  hb_shape_full (hb_font_t          *font,
           hb_buffer_t        *buffer,
           const hb_feature_t *features,
           unsigned int        num_features,
           const char * const *shaper_list);
*/

/*
  HB_EXTERN const char **
  hb_shape_list_shapers (void);
*/

VALUE
shape_list_shapers(
  VALUE self
) {
  VALUE obj = rb_ary_new();
  const char **shapers = hb_shape_list_shapers();
  while (*shapers) {
    rb_ary_push(obj, rb_str_new_cstr(*shapers));
    shapers++;
  }
  return obj;
}

void
setup_harfbuzz_shape(
  VALUE mHarfbuzz
) {
  rb_define_singleton_method(mHarfbuzz, "shapers", shape_list_shapers, 0);
  rb_define_singleton_method(mHarfbuzz, "shape", shape_shape, 3);
}