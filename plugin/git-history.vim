

" fu! s:git(...)
"
" endf
"

fu! s:gh_syntax() abort

  let b:current_syntax = 'githistory'
  let conceal = has('conceal') ? ' conceal' : ''
  let arg = exists('b:githistory_arguments') ? b:githistory_arguments : ''

  sy case match
  sy spell toplevel
  set conceallevel 2

  syn sync fromstart
  set foldmethod=syntax
  " 2018-01-15 19:01:23 -0500
  "  syn match GitHistoryDateTime  "\(19\|20\)[0-9][0-9]-\(0[1-9]\|1[0-2]\)-[0-9][0-9] \(0[0-9]\|1[0-9]\|2[0-3]\)\(:[0-9][0-9]\{2\}\) -[0-9]\{4\}"
  syn match GitHistoryDateTime  "\v(19|20)[0-9][0-9]-(0[1-9]|1[0-2])-[0-9][0-9] (0[0-9]|1[0-9]|2[0-3])(:[0-9][0-9]){2} -[0-9]{4}"
  syn match GitHistoryHeadLine  "^[\*|\/ ]*>> .*" transparent contains=GitHistoryEmail,GitHistoryDateTime,GitHistoryHashShort
  syn match GitHistoryTagLine   "^[|\/ ]*(tag: .*"
  syn match GitHistoryEmail     "<[a-zA-Z0-9_.+-]\+@[a-zA-Z0-9-]\+\.[a-zA-Z0-9-.]\+>" conceal cchar=@
  syn match GitHistoryHashLong  "[a-fA-F0-9]{40}"
  syn match GitHistoryHashShort " [a-fA-F0-9]\{7\} "
  syn match GitHistoryDateTime "[a-fA-F0-9]{7}"
  syn match GitHistoryKeywords   " (Signed-off-by|Acked-by|Reviewed-by|Tested-by|Suggested-by|Cc):"
  syn keyword GitHistoryKeywords   Signed-off-by Acked-by Reviewed-by Tested-by Suggested-by Cc
  syn match FugitiveblameBlank                      "^\s\+\s\@=" nextgroup=FugitiveblameAnnotation,fugitiveblameOriginalFile,FugitiveblameOriginalLineNumber skipwhite
  " conceal Email after Name
  exec 'syn match GitHistoryEmail         " *\d\+)\@=" contained containedin=FugitiveblameAnnotation' . conceal

  syn region OneCommit start="^[|\/ ]*\*" end="^[|\/ ]*\*" transparent fold
  hi def link GitHistoryKeywords    Keyword
  hi def link GitHistoryDateTime    Error
  hi def link GitHistoryHashShort    Error



endf

fu! s:git_history(...)
  " let l:gitcmd='git log --color --graph --decorate --abbrev-commit --full-history --all --date-order --date=local --format="((\%ci  \%h))\%an<\%ae>:\%s\%+d\%+b"'
  let l:gitcmd='git log --graph --decorate --abbrev-commit --full-history --all --date-order --date=local --format="<< ((\%ci  \%h  \%an<\%ae>))\%s\%+d\%+b >>" '
  let l:gitcmd .= '-n 20'
  execute 'set nowrap'
  execute 'r! ' . l:gitcmd
  " remove space at the end of each line
  execute '%s/\s\+$//'
  "| perl -ne 'printf("%-36s%s",($_ =~ s/\(\(([^\)]+)\)\)//)?$1:"",$_)'

endf

" command! -bang -nargs=0 -complete=command OperatorMap             call s:operator_map(<f-args>)
command! -bang -nargs=0 GitMan call s:git_history()
