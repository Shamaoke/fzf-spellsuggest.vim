vim9script
##                        ##
# ::: Fzf Spellsuggest ::: #
##                        ##

import 'fzf-run.vim' as Fzf

var spec = {
  'set_fzf_data': (data) =>
    expand("<cword>")
      ->spellsuggest()
      ->writefile(data),

  'set_tmp_file': ( ) => tempname(),
  'set_tmp_data': ( ) => tempname(),

  'geometry': {
    'width': 0.8,
    'height': 0.8
  },

  'commands': {
    'enter': (entry) => $'normal "_ciw{entry}'
  },

  'term_command': [
    'fzf',
    '--no-multi',
    '--bind=alt-h:first,alt-e:last',
    '--expect=enter'
  ],

  'set_term_command_options': (data) =>
    [ $"--bind=start:reload^cat '{data}'^" ],

  'term_options': {
    'hidden': true,
    'out_io': 'file'
  },

  'popup_options': {
    'title': '─ ::: Fzf Spellsuggest ::: ─',
    'border': [1, 1, 1, 1],
    'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└']
  }
}

command FzfSS Fzf.Run(spec)

# vim: set textwidth=80 colorcolumn=80:
