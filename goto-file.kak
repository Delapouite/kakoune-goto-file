decl -hidden str goto_file_suffix ''
decl -hidden str goto_index_suffix ''

hook global WinSetOption filetype=javascript %{
  set buffer goto_file_suffix '.js'
  set buffer goto_index_suffix '/index.js'
}

def goto-file -docstring 'goto file-path in first string on current line' %{
  # select-next-string
  exec gh/['"][^'"\n]*?['"]<ret>
  # shrink-selection
  exec '<a-:>H<a-;>L'
  # relative path handling
  decl -hidden str goto_dir "%sh{dirname $kak_buffile}/"

  try %{
    edit -existing "%opt{goto_dir}%val{selection}"
  } catch %{
    try %{
      # with file suffix
      edit -existing "%opt{goto_dir}%val{selection}%opt{goto_file_suffix}"
    } catch %{
      try %{
        # with index suffix
        edit -existing "%opt{goto_dir}%val{selection}%opt{goto_index_suffix}"
      } catch %{
        echo "gf: files not found %opt{goto_dir}%val{selection} (%opt{goto_file_suffix}|%opt{goto_index_suffix})"
      }
    }
  }
}

# Suggested mappings

#map global goto f '<esc>:goto-file<ret>' -docstring 'file'
#map global goto F f -docstring 'file (legacy)'
