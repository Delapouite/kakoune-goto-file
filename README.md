# kakoune-goto-file

[kakoune](http://kakoune.org) plugin to jump between dependent files.

## Install

Add `goto-file.kak` to your autoload dir: `~/.config/kak/autoload/`.

Or via [plug.kak](https://github.com/andreyorst/plug.kak):

```
plug 'delapouite/kakoune-goto-file' %{
  # Suggested mappings
  map global goto f '<esc>: goto-file<ret>' -docstring 'file'
  map global goto F f -docstring 'file (legacy)'
}
```

## Usage

Kakoune provides a `gf` command to jump to the path highlighted by the main selection.

It works, but it can be tedious to always have to craft the main selection before hand.

This plugin offers a `goto-file` command which finds the first string on the current line
and attempts to `edit -existing` its content.
If it fails, it will try again by appending the content of `goto_file_suffix` option 
and try once more by appending `goto_index_suffix`.

### JavaScript example

```js
const UserModel = require('./models/user')
```

With the cursor at the beginning of the line, the `goto-file` command will attempt to edit
`./models/user`. This will fail because this file does not exist.
So it appends `goto_file_suffix` which is `.js` (previously set by a `WinSetOption` hook).
It can now edit `./models/user.js` correctly.

Node.js has an extra resolve mechanism which will also try to require a file named `index.js`
if the `require()` content points to a dir. This is the purpose of the `goto_index_suffix` option.

Finally, if the string is an absolute name like `require('express')`, `gf` will try to edit this
module main file using a mix of `npm root` and `npm view foo main`.

Note: this plugin does not work (yet) in the following scenarios where the module name is a core module
like `fs`:

```js
const fs = require('fs')
```

## Mappings

To jump backward you can use the `<c-o>` as usual (and `<c-i>` to jump forward).
Also `ga` lets you go back and forth between the current and previous buffer.

## See also

- [kakoune-cd](https://github.com/Delapouite/kakoune-cd)
- [kakoune-npm](https://github.com/Delapouite/kakoune-npm)
- [kak-lsp](https://github.com/ul/kak-lsp) - for goto definition support

## Licence

MIT
