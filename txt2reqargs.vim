:%s/#\_.\{-}\(\(^\s\{6}\a\)\|\(^\-\)\)\@=/\r/g
:g/^- name:/d
:%s/^  action: \(.*\)/iab \1: \1:
:g!/[=:]/d
:g/=/-1j
:g!/=/d
:%s/$/<C-r>=rocannon#Eatchar('\\s')<CR>
ggO" Auto-generated by reqargs.vim
:w! gen/reqargs.vim
:q!
