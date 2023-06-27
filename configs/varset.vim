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
:set autoindent
:set smartindent
:set cindent

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
inoremap <silent> っj <ESC>

"下部分にターミナルウィンドウを作る
function! Myterm()
    split
    wincmd j
    resize 10
    terminal
    wincmd k
endfunction
command! Myterm call Myterm()

"起動時にターミナルウィンドウを設置
if has('vim_starting')
    Myterm
endif

"上のエディタウィンドウと下のターミナルウィンドウ(ターミナル挿入モード)を行き来
tnoremap <C-t> <C-\><C-n><C-w>k
nnoremap <C-t> <C-w>ji
"ターミナル挿入モードからターミナルモードへ以降
tnoremap <Esc> <C-\><C-n>
"タブを押してコードを補完
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"ファイルタイプごとにコンパイル/実行コマンドを定義
function! Setup()
    "フルパスから拡張子を除いたもの
    let l:no_ext_path = printf("%s/%s", expand("%:h"), expand("%:r"))
    "各言語の実行コマンド
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

"ファイルを開き直したときに実行コマンドを再設定
autocmd BufNewFile,BufRead * Setup
