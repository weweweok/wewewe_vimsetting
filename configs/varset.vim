" ターミナルを常に挿入モードで
autocmd TermOpen * startinsert

"C++,Java等のインラインブロックを中括弧付きのブロックに展開
nnoremap <C-j> ^/(<CR>%a{<CR><Esc>o}<Esc>

"ターミナル挿入モードからターミナルモードへ以降
tnoremap <Esc> <C-\><C-n>
"タブを押してコードを補完
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>":"\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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
