vim9script
##
# ::: Fzf Spellsuggest :::
#

import './fzf-options.vim' as Fzf

def FzfSpellsuggestSource(word: string): list<string>
  return spellsuggest(expand(word))
enddef

def FzfSpellsuggestSink(word: string): void
  var mod = 'normal'
  var reg = '"_'
  var cmd = 'ciw'
  var sub = word

  var cmd_str = $"{mod} {reg}{cmd}{sub}"

  execute cmd_str
enddef

export def FzfSpellsuggest(): void
  var fzf_spellsuggest_options = {
    'source': FzfSpellsuggestSource("<cword>"),
    'sink': FzfSpellsuggestSink
  }

  var fzf_spec = extend(fzf_spellsuggest_options, Fzf.options)

  fzf#run(fzf_spec)
enddef

