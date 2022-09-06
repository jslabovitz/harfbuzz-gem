The Harfbuzz gem is a Ruby interface to the Harfbuzz text shaping engine. By using this gem, some input text, a font file, and a list of features, you can convert Unicode text to glyph descriptions that are ready to be rendered.

For more information about Harfbuzz itself, see [harfbuzz.org](http://harfbuzz.org), or the [Harfbuzz manual](http://behdad.github.io/harfbuzz/).

For an example of use, see [examples/example.rb](https://github.com/jslabovitz/harfbuzz-gem/blob/master/examples/example.rb). You can run this from the base directory of the gem:

    ruby examples/example.rb


## Installation

You must have the Harfbuzz library available on your system. OS X users can use Homebrew to install it:

    brew install harfbuzz

Once you've installed the Harfbuzz library, install this gem by the usual:

    sudo gem install harfbuzz

or if you're using a Ruby installed in Homebrew, as a normal user:

    gem install harfbuzz


## Design philosophy

The Harfbuzz gem is composed of two layers: a low-level direct interface to Harfbuzz itself, and a high-level abstract interface that uses traditional Ruby objects and idioms.

The low-level interface is a one-to-one mapping of Harfbuzz C functions to Ruby methods, implemented using the [FFI](https://github.com/ffi/ffi) library. For example, the Harfbuzz C function `hb_version_string()`  is available in Ruby as `Harfbuzz.hb_version_string`. However, as the low-level methods return C pointers wrapped in FFI objects, this layer is generally not useful to a Ruby programmer.

The high-level interface abstracts the C functions, structures, and pointers into Ruby objects. For example, the aftermentioned `hb_version_string()` function is more usefully available via `Harfbuzz.version_string`, which returns a Ruby string containing with the version of the Harfbuzz library.

Where appropriate, Ruby classes have been constructed to map to the concepts in Harfbuzz. Hence:

| C           | Ruby
| ----------- | ----
| hb_blob_t   | Harfbuzz::Blob
| hb_buffer_t | Harfbuzz::Buffer
| hb_face_t   | Harfbuzz::Face
| hb_font_t   | Harfbuzz::Font

The shaping method itself is in the base Harfbuzz module, as `Harfbuzz.shape(...)`.


## Caveats & bugs

Only a small number of basic Harfbuzz functions are mapped to Ruby methods. More will be added as needed.

There is no documentation except this file and the example script.

Memory management may not be correct. (I've seen crashes when processing large amounts of text.)


## To-do

- Update for recent (version 4.0+) versions of Harfbuzz.

- Implement hb_buffer_set_* functions.

- Add documentation.

- Investigate [Harfbuzz-Lua bindings](https://github.com/deepakjois/luaharfbuzz/wiki) for inspiration.


## Feedback

As this is a new project, I'd love to hear your feedback. Email me at [johnl@johnlabovitz.com](mailto:johnl@johnlabovitz.com).