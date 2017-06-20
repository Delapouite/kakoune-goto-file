# kakoune-goto-file

[kakoune](http://kakoune.org) plugin to jump between dependent files.

## Install

Add `goto-file.kak` to your autoload dir: `~/.config/kak/autoload/`.

## Usage

Kakoune provides a `gf` command to jump to the path highlighted by the main selection.

It works, but it can be tedious to always have to craft the main selection before hand.

This plugin offers a `goto-file` command which find the first string on the current line
and attempts to `edit -existing` its content. If it fails, it will try again by appending
the content of `goto_file_suffix` option, and try once more by appending `goto_index_suffix`.

Here's a JavaScript example:

```js
const UserModel = require('./models/user')
```

With the cursor at the beginning of the line, the `goto-file` command will attempt to edit
`./models/user`. This will fail because this file does not exist.
So it appends `goto_file_suffix` which is `.js` (previously set by a hook).
It can now edit `./models/user.js` correctly.

Node.js has an extra resolve mechanism which will also try to require a file named `index.js`
if the `require()` content points to a dir. This is the purpose of the `goto_index_suffix` option.

To jump backward you can use the `<c-o>` as usual (and `<c-i>` to jump forward).
Also `ga` lets you go back and forth between the current and previous buffer.

Note: this plugin does not work (yet) in the following scenarios where the module name is absolute
(either a core lib or located in `node_modules`):

```js
const fs = require('fs')
const express = require('express')
```

```
# Suggested mappings

map global goto f '<esc>:goto-file<ret>' -docstring 'file'
map global goto F f -docstring 'file (legacy)'
```

## See also

- [kakoune-cd](https://github.com/Delapouite/kakoune-cd)

## Licence

MIT
