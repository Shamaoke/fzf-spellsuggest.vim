vim9script

import './fzf-options' as fzf

##
# ::: Fzf Spellsuggest :::
#

const fzf_spellsuggest_options = {
  'source': FzfSpellsuggestSource(),
  'sink': FzfSpellsuggestSink
}

const fzf_spec = extend(copy(fzf_spellsuggest_options), fzf.options)

def FzfSpellsuggestSource(): list<string>
  return spellsuggest(expand("<cwrod>"))
enddef

def FzfSpellsuggestSink(word: string)
  var mod = 'normal'
  var reg = '"_'
  var cmd = 'ciw'
  var sub = word

  var cmd_str = $"{mod} {reg}{cmd}{sub}"

  execute cmd_str
enddef

export def FzfSpellsuggest()
  fzf#run(fzf_spec)
enddef

