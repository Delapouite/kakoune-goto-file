# in some languages the file extension is optional
declare-option -hidden str goto_file_suffix ''
declare-option -hidden str goto_index_suffix ''

hook global WinSetOption filetype=(javascript|ecmascript) %{
  # require() / import from
  set-option buffer goto_file_suffix '.js'
  set-option buffer goto_index_suffix '/index.js'
}

hook global WinSetOption filetype=(typescript) %{
  # import from
  set-option buffer goto_file_suffix '.ts'
  set-option buffer goto_index_suffix '/index.ts'
}

define-command goto-file -docstring 'goto filepath in string on current line' %{
  # select-next-string
  execute-keys gh /['"][^'"\n]*?['"]<ret>
  # shrink-selection
  execute-keys '<a-:>H<a-;>L'
  # relative path handling
  declare-option -hidden str goto_dir "%sh{dirname ""$kak_buffile""}/"

  try %{
    # relative path without suffix
    edit -existing "%opt{goto_dir}%val{selection}"
  } catch %{
    # with file suffix
    edit -existing "%opt{goto_dir}%val{selection}%opt{goto_file_suffix}"
  } catch %{
    # with index suffix
    edit -existing "%opt{goto_dir}%val{selection}%opt{goto_index_suffix}"
  } catch %{
    # package.json.main in node_modules
    declare-option -hidden str goto_main "%sh{main=\"$(npm view $kak_selection main)\"; [ -n \"$main\" ] && echo \"$main\" || echo 'index.js'}"
    edit -existing "%sh{npm root}/%val{selection}/%opt{goto_main}"
  } catch %{
    fail "gf: files not found %opt{goto_dir}%val{selection} (%opt{goto_file_suffix}|%opt{goto_index_suffix})"
  }
}

# Suggested mappings

#map global goto f '<esc>: goto-file<ret>' -docstring 'file'
#map global goto F f -docstring 'file (legacy)'
