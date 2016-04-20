#include <ruby.h>
#include <harfbuzz/hb.h>
#include "harfbuzz.h"

VALUE cHarfbuzz_Face;

#if 0
typedef struct hb_face_t hb_face_t;

HB_EXTERN hb_face_t *
hb_face_create (hb_blob_t    *blob,
    unsigned int  index);

typedef hb_blob_t * (*hb_reference_table_func_t)  (hb_face_t *face, hb_tag_t tag, void *user_data);

/* calls destroy() when not needing user_data anymore */
HB_EXTERN hb_face_t *
hb_face_create_for_tables (hb_reference_table_func_t  reference_table_func,
         void                      *user_data,
         hb_destroy_func_t          destroy);

HB_EXTERN hb_face_t *
hb_face_get_empty (void);

HB_EXTERN hb_face_t *
hb_face_reference (hb_face_t *face);

HB_EXTERN void
hb_face_destroy (hb_face_t *face);

HB_EXTERN hb_bool_t
hb_face_set_user_data (hb_face_t          *face,
           hb_user_data_key_t *key,
           void *              data,
           hb_destroy_func_t   destroy,
           hb_bool_t           replace);


HB_EXTERN void *
hb_face_get_user_data (hb_face_t          *face,
           hb_user_data_key_t *key);

HB_EXTERN void
hb_face_make_immutable (hb_face_t *face);

HB_EXTERN hb_bool_t
hb_face_is_immutable (hb_face_t *face);


HB_EXTERN hb_blob_t *
hb_face_reference_table (hb_face_t *face,
       hb_tag_t   tag);

HB_EXTERN hb_blob_t *
hb_face_reference_blob (hb_face_t *face);

HB_EXTERN void
hb_face_set_index (hb_face_t    *face,
       unsigned int  index);

HB_EXTERN unsigned int
hb_face_get_index (hb_face_t    *face);
#endif

static VALUE
face_index(
  VALUE self
) {
  hb_face_t *hb_face = get_face(self);
  return INT2FIX(hb_face_get_index(hb_face));
}

#if 0
HB_EXTERN void
hb_face_set_upem (hb_face_t    *face,
      unsigned int  upem);
#endif

#if 0
HB_EXTERN unsigned int
hb_face_get_upem (hb_face_t *face);
#endif

static VALUE
face_upem(
  VALUE self
) {
  hb_face_t *hb_face = get_face(self);
  return INT2FIX(hb_face_get_upem(hb_face));
}

#if 0
HB_EXTERN void
hb_face_set_glyph_count (hb_face_t    *face,
       unsigned int  glyph_count);
#endif

#if 0
HB_EXTERN unsigned int
hb_face_get_glyph_count (hb_face_t *face);
#endif

VALUE
face_glyph_count(
  VALUE self
) {
  hb_face_t *hb_face = get_face(self);
  return INT2FIX(hb_face_get_glyph_count(hb_face));
}

void
face_free(
  hb_face_t *hb_face
) {
  hb_face_destroy(hb_face);
}

VALUE
face_new(
  VALUE self,
  VALUE blob,
  VALUE index
) {
  hb_blob_t *hb_blob = get_blob(blob);
  hb_face_t *hb_face = hb_face_create(hb_blob, FIX2INT(index));
  VALUE face = Data_Wrap_Struct(cHarfbuzz_Face, 0, face_free, hb_face);
  rb_obj_call_init(face, 0, 0);
  return face;
}

void
setup_harfbuzz_face(
  VALUE mHarfbuzz
) {
  cHarfbuzz_Face = rb_define_class_under(mHarfbuzz, "Face", rb_cObject);
  rb_define_singleton_method(cHarfbuzz_Face, "new", face_new, 2);
  rb_define_method(cHarfbuzz_Face, "index", face_index, 0);
  rb_define_method(cHarfbuzz_Face, "upem", face_upem, 0);
  rb_define_method(cHarfbuzz_Face, "glyph_count", face_glyph_count, 0);
}