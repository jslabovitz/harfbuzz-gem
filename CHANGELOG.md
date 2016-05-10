# CHANGELOG

Only important or user-facing changes are listed here. See commit log for typos, etc.

## 0.3 / 2016-05-10

- Add new Harfbuzz bindings:
    - hb_font_extents() and hb_glyph_extents() (code by Stafford Brunk)
    - hb_font_get_glyph_name() and hb_font_get_glyph_from_name()
    - hb_version_atleast() (also implemented by Stafford Brunk)
- Add convenience accessors to most classes (no more foo[:bar])
- Use hb_version_atleast() to check for minimum version number, instead of Gem's magic.
- Show additional font information in example script.
- Add tests to cover most of Harfbuzz API.
- Add a simple benchmark to test times and possibly crashes (run 'rake benchmark').
- Ensure string added to buffer is indeed UTF-8.
- Build blob from provided data if not already a blob.

## 0.2 / 2015-11-15

- Show additional font information in example script.
- Call correct finalizer when hb_face is destroyed.
- Add version check & requirement to ensure correct version of Harfbuzz C library.
- Add to-do list.

## 0.1 / 2015-10-02

- Initial release.