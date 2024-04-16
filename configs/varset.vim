"行番号を表示(切り替え)
set number
"タブ文字の代わりにスペースを使う(切り替え)
set expandtab
"プログラミング言語に合わせて適切にインデントを自動挿入(切り替え)
set smartindent
"各コマンドやsmartindentで挿入する空白の量(数値)
set shiftwidth=4
"Tabキーで挿入するスペースの数(数値)
set softtabstop=4
"カレントディレクトリを自動で移動
set autochdir
"バッファ内で扱う文字コード(文字列)
set encoding=utf-8
"書き込む文字コード(文字列) : この場合encodingと同じなので省略可
set fileencoding=utf-8
"読み込む文字コード(文字列のリスト) : この場合UTF-8を試し、だめならShift_JIS
set fileencodings=utf-8,cp932
"Vimの無名レジスタとシステムのクリップボードを連携(文字列のリスト) : ダメならxclipをインストールで使えるかも
set clipboard+=unnamed,unnamedplus
"eコマンド等でTabキーを押すとパスを保管する(文字列のリスト) : この場合まず最長一致文字列まで補完し、2回目以降は一つづつ試す
set wildmode=longest,full

"インデントに関して
set autoindent
set smartindent
set cindent 

"{ + Enterで括弧を補完して改行する
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

"C++,Java等のインラインブロックを中括弧付きのブロックに展開
nnoremap <C-j> ^/(<CR>%a{<CR><Esc>o}<Esc>
"カーソル上の単語を置換
nnoremap <expr> S* ':%s/\<' . expand('<cword>') . '\>/'

"挿入モード終了時にIMEをオフ
inoremap <silent> <Esc> <Esc>:call system('fcitx-remote -c')<CR>

"jキーを二度押しでESCキー
inoremap <silent> jj <Esc>

"ターミナル挿入モードからターミナルモードへ以降
tnoremap <Esc> <C-\><C-n>
"タブを押してコードを補完
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>":"\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" telescope
nnoremap <C-f> <cmd>Telescope find_files<cr>
nnoremap <C-p> <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"24ビットカラー
set termguicolors



"ファイルタイプごとにコンパイル/実行コマンドを定義
function! Setup()
    "フルパスから拡張子を除いたもの
    let l:no_ext_path = printf("%s/%s", expand("%:h"), expand("%:r"))

    let g:compile_command_dict = {
                \'c': printf('gcc -std=gnu11 -O2 -lm -o %s.out %s && %s/%s.out', expand("%:r"), expand("%:p"), expand("%:h"), expand("%:r")),
                \'cpp': printf('g++ -std=gnu++17 -O2 -o %s.out %s && %s/%s.out', expand("%:r"), expand("%:p"), expand("%:h"), expand("%:r")),
                \'java': printf('javac %s && java %s', expand("%:p"), expand("%:r")),
                \'cs': printf('mcs -r:System.Numerics -langversion:latest %s && mono %s/%s.exe', expand("%:p"), expand("%:h"), expand("%:r")),
                \'python': printf('python3 %s', expand("%:p")),
                \'ruby': printf('ruby %s', expand("%:p")),
                \'javascript': printf('node %s', expand("%:p")),
                \'sh': printf('chmod u+x %s && %s', expand("%:p"), expand("%:p"))
                \}
    "実行コマンド辞書に入ってたら実行キーバインドを設定
    if match(keys(g:compile_command_dict), &filetype) >= 0
        "下ウィンドウがターミナルであることを前提としている
        nnoremap <expr> <F5> '<C-w>ji<C-u>' . g:compile_command_dict[&filetype] . '<CR>'
    endif
endfunction
command! Setup call Setup()

function! AddIndentWhenEnter()
    if getline(".")[col(".")-1] == "}" && getline(".")[col(".")-2] == "{"
        return "\n\t\n\<UP>\<END>"
    else
        return "\n"
    endif
endfunction
inoremap <silent> <expr> <CR> AddIndentWhenEnter()

function! s:clang_format()
  let now_line = line(".")
  exec ":%! clang-format"
  exec ":" . now_line
endfunction

function! DeleteParenthesesAdjoin()
    let pos = col(".") - 1  " カーソルの位置．1からカウント
    let str = getline(".")  " カーソル行の文字列
    let parentLList = ["(", "[", "{", "\'", "\""]
    let parentRList = [")", "]", "}", "\'", "\""]
    let cnt = 0

    let output = ""

    " カーソルが行末の場合
    if pos == strlen(str)
        return "\b"
    endif
    for c in parentLList
        " カーソルの左右が同種の括弧
        if str[pos-1] == c && str[pos] == parentRList[cnt]
            call cursor(line("."), pos + 2)
            let output = "\b"
            break
        endif
        let cnt += 1
    endfor
    return output."\b"
endfunction
" BackSpaceに割り当て
inoremap <silent> <BS> <C-R>=DeleteParenthesesAdjoin()<CR>

if executable('clang-format')
  augroup cpp_clang_format
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.[ch]pp call s:clang_format()
  augroup END
endif

"ファイルを開き直したときに実行コマンドを再設定
autocmd BufNewFile,BufRead * Setup
