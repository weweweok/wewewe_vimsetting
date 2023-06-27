let g:lsp_settings_servers_dir = '~/.config/nvim/lsp/'

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

"configディレクトリより各種vimファイルロード
source ~/.config/nvim/configs/plugs.vim

let splt = split(glob("~/.config/nvim/configs/" . "*.vim"))
  
for file in splt
	" 読み込んだファイルを表示するもの消しても大丈夫
	echo "load " . file
	" ファイルの読み込み
	execute 'source' file
endfor


