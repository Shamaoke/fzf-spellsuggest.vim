vim9script
##                        ##
# ::: Fzf Spellsuggest ::: #
##                        ##

var config = {
  'fzf_default_command': $FZF_DEFAULT_COMMAND,

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

def SetExitCb( ): func(job, number): string

  def Callback(job: job, status: number): string
    var commands: list<string>

    commands = ['quit']

    return execute(commands)
  enddef

  return Callback

enddef

def SetCloseCb(file: string): func(channel): string

  def Callback(channel: channel): string
    var data: list<string> = readfile(file)

    if data->len() < 2
      return execute([':$bwipeout', $"call delete('{file}')"])
    endif

    var key   = data->get(0)
    var entry = data->get(-1)

    var commands: list<string>

    commands = [':$bwipeout', config['commands'][key](entry), $"call delete('{file}')"]

    return execute(commands)
  enddef

  return Callback

enddef

def ExtendTermCommandOptions(options: list<string>): list<string>
  var extensions = [ ]

  return options->extendnew(extensions)
enddef

def ExtendTermOptions(options: dict<any>): dict<any>
  var tmp_file = tempname()

  var extensions =
    { 'out_name': tmp_file,
      'exit_cb': SetExitCb(),
      'close_cb': SetCloseCb(tmp_file) }

  return options->extendnew(extensions)
enddef

def ExtendPopupOptions(options: dict<any>): dict<any>
  var extensions =
    { 'minwidth':  (&columns * config['geometry']->get('width'))->ceil()->float2nr(),
      'minheight': (&lines * config['geometry']->get('height'))->ceil() ->float2nr() }

   return options->extendnew(extensions)
enddef

def SetFzfCommand( ): void

  var command: string

  def ListSuggestions( ): string
    var suggestions = expand("<cword>")->spellsuggest()->join('\\n')

    return suggestions
  enddef

  command = $"echo -n {ListSuggestions()}"

  $FZF_DEFAULT_COMMAND = command

enddef

def RestoreFzfCommand( ): void
  $FZF_DEFAULT_COMMAND = config->get('fzf_default_command')
enddef

def Start( ): void
  term_start(
    config
      ->get('term_command')
      ->ExtendTermCommandOptions(),
    config
      ->get('term_options')
      ->ExtendTermOptions())
    ->popup_create(
        config
          ->get('popup_options')
          ->ExtendPopupOptions())
enddef

def FzfSS( ): void
  SetFzfCommand()

  try
    Start()
  finally
    RestoreFzfCommand()
  endtry
enddef

command FzfSS FzfSS()

# vim: set textwidth=80 colorcolumn=80:
