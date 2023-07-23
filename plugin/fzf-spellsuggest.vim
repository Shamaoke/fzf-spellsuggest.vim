vim9script
##                        ##
# ::: Fzf Spellsuggest ::: #
##                        ##

import 'fzf-run.vim' as Fzf

var spec = {
  'fzf_default_command': $FZF_DEFAULT_COMMAND,

  'set_fzf_data': ( ) => expand("<cword>")->spellsuggest()->join('\\n'),

  'set_fzf_command': (data) => $"echo -n \"{data}\"",

  'set_tmp_file': ( ) => tempname(),

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
    '--expect=enter'
  ],

  'set_term_command_options': ( ) => [ ],

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
