# yanktmp.vim
https://github.com/rtakasuke/yanktmp.vim

##概要
異なるプロセス間での yank & paste を可能にするVimプラグインです。  
screenやtmuxを使っている方におすすめです。  

`:call YanktmpYank()` 文字列をtempファイルに書き出します。  
`:call YanktmpPaste_p()` `YanktmpPaste_P()` 文字列をtempファイルから paste します。
  
secondlifeさんのyanktmp.vimがオリジナルです。  
https://github.com/vim-scripts/yanktmp.vim  
オリジナルを基に改造を加えています。
  

##オリジナルとの違い
オリジナルは行単位でのyankのみでしたが、  
文字単位でのyankもできるようになりました。  
ただし、矩形選択はごめんなさい。  


##使い方
####インストール
NeoBundleの場合

```
NeoBundle 'rtakasuke/yanktmp.vim'
```

####キーマッピング

```
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>
```

####tempファイル
デフォルトは `/tmp/vimyanktmp` および `/tmp/vimyanktmp_mode` です。  
下記のように設定すれば変更もできます。

```
let g:yanktmp_file      = '/tmp/example_tmp_file'
let g:yanktmp_mode_file = '/tmp/vimyanktmp_mode'
```
