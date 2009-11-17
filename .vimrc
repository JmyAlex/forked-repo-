set number " Включает отображение номеров строк
set autoindent " Копирует отступ от предыдущей строки
set nowrap " Отключить перенос строк
set noignorecase " Не игнорировать регистр букв при поиске
set list " Включить подсветку невидимых символов
set listchars=tab:·\ ,trail:· " Настройка подсветки невидимых символов
: command Wsudo set buftype=nowrite | silent execute ':%w !sudo tee %' | set buftype= | e! i% "После чего можно сохранятся используя sudo выполнив команду :Wsudo"

" Подсветка синтаксиса - для автоопределения типа файлов:
filetype plugin on
filetype indent on
" Комментирование строк
map <F9> ^i//<Esc>
imap <F9> <Esc>^i//<Esc>
vmap <F9> "cdi/**/<Esc>h"cP

set tabstop=4 " Размер табуляции
set shiftwidth=4 " Размер сдвига при нажатии на клавиши < и >
syntax on " Включаем подсветку синтаксиса
set hlsearch " Включаем подсветку выражения, которое ищется в тексте
set incsearch " При поиске перескакивать на найденный текст в процессе набора строки
set nobackup " Не создавать бэкапы
set noswapfile " Отключает создание swap файлов
"set dir=~/.vim/swp " Все swap файлы будут помещаться в эту папку
set ignorecase " Не игнорировать регистр букв при поиске
set undolevels=100 " Размер истории для отмены
set fileencodings=utf-8,cp1251,koi8-r,cp866 " Список кодировок файлов для автоопределения
set visualbell " Включает виртуальный звонок (моргает, а не бибикает при ошибках)
set nowrapscan " Останавливать поиск при достижении конца файла
set whichwrap=b,s,<,>,[,],l,h " Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
set fdm=syntax " Метод фолдинга - по синтаксису
set foldlevel=9999999 " Разворачиваем все свернутые фолдингом группировки
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P
set laststatus=2 " Отображать статусную строку для каждого окна
set guifont=Monospace\ 10

" highlighting tabs, trailing white space and non braking spaces
if &term !=# "linux"
    set list listchars=tab:\➜\ ,trail:·,nbsp:-
endif

"""""""""""""""""""""""""""""
" 256 colors only if you can handle it
au VimEnter *
	      \ if &term == 'xterm' || &term == 'xterm-color' |
	      \    set t_Co=256     |
	      \ endif
	      
"цветовая схема:
"colorscheme zenburn 
colorscheme molokai
"colorscheme tabula
"colorscheme professional


""""""""""""""""""""""""""""""
set nocompatible
"set background=dark
set background=light
""""""""""""""""""""""""""""""
" смотрим файлы .doc
au BufReadPost *.doc silent %!antiword "%"
""""""""""""""""""""""""""""""


" Очистить подсветку последнего найденного выражения
nmap <F2> :nohlsearch<CR>


" Более привычные Page Up/Down, когда курсор остаётся в той же строке,
" а не переносится вверх/вниз экрана, как при стандартном PgUp/PgDown.
" Поскольку по умолчанию прокрутка по C-Y/D происходит на полэкрана,
" привязка делается к двойному нажатию этих комбинаций.
nmap <PageUp> <C-U><C-U>
imap <PageUp> <C-O><C-U><C-O><C-U>
nmap <PageDown> <C-D><C-D>
imap <PageDown> <C-O><C-D><C-O><C-D>


" Проверка орфографии
if version >= 700
 " По умолчанию проверка орфографии выключена.
    setlocal spell spelllang=
    setlocal nospell
    function ChangeSpellLang()
        if &spelllang =~ "en_us"
            setlocal spell spelllang=ru
            echo "spelllang: ru"
        elseif &spelllang =~ "ru"
            setlocal spell spelllang=
            setlocal nospell
            echo "spelllang: off"
        else
            setlocal spell spelllang=en_us
            echo "spelllang: en"
        endif
    endfunc

    " Горячая клавиша для переключения языка 
    map <F11> <Esc>:call ChangeSpellLang()<CR>
endif


" Меню смены кодировок
set wildmenu
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>
map <F6> :emenu Encoding.<TAB>


" Смена кодировок
" http://www.opennet.ru/base/rus/vim_rus_text.txt.html

" <F7> меняет по очереди формат концов строк (dos - <CR> <NL>, unix - <NL>, mac - <CR>)
map <F7> :execute RotateFileFormat()<CR>
vmap <F7> <C-C><F7>
imap <F7> <C-O><F7>
let b:fformatindex=0
function! RotateFileFormat()
 let y = -1
 while y == -1
  let encstring = "#unix#dos#mac#"
  let x = match(encstring,"#",b:fformatindex)
  let y = match(encstring,"#",x+1)
  let b:fformatindex = x+1
  if y == -1
   let b:fformatindex = 0
  else
   let str = strpart(encstring,x+1,y-x-1)
   return ":set fileformat=".str
  endif
 endwhile
endfunction

" <F8> переоткрывает файл в разных кодировках через :e ++enc=кодировка
map <F8> :execute RotateEnc()<CR>
vmap <F8> <C-C><F8>
imap <F8> <C-O><F8>
let b:encindex=0
function! RotateEnc()
 let y = -1
 while y == -1
  let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
  let x = match(encstring,"#",b:encindex)
  let y = match(encstring,"#",x+1)
  let b:encindex = x+1
  if y == -1
   let b:encindex = 0
  else
   let str = strpart(encstring,x+1,y-x-1)
   return ":e ++enc=".str
  endif
 endwhile
endfunction

" <Shift+F8> тоже что и <F8>, но предварительно меняет внутреннюю
" кодировку vim на равную кодировке файла. Это нужно когда vim умничает и
" команда :e ++enc=кодировка для него не указ. Минус этого метода в том,
" что когда внутренняя кодировка равна 8bit-cp866, то vim некоторые
" русские буквы показывает неверно, но именно показывает, поскольку если
" конвертировать, то ничего не портится (сравнить можно с результатом
" работы <F8>).
map <S-F8> :execute ForceRotateEnc()<CR>
vmap <S-F8> <C-C><S-F8>
imap <S-F8> <C-O><S-F8>
let b:encindex=0
function! ForceRotateEnc()
 let y = -1
 while y == -1
  let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
  let x = match(encstring,"#",b:encindex)
  let y = match(encstring,"#",x+1)
  let b:encindex = x+1
  if y == -1
   let b:encindex = 0
  else
   let str = strpart(encstring,x+1,y-x-1)
   :execute "set encoding=".str
   return ":e ++enc=".str
  endif
 endwhile
endfunction

" <Ctrl+F8> меняет кодировку файла, то есть после его сохранения он будет
" конвертирован
map <C-F8> :execute RotateFEnc()<CR>
vmap <C-F8> <C-C><C-F8>
imap <C-F8> <C-O><C-F8>
let b:fencindex=0
function! RotateFEnc()
 let y = -1
 while y == -1
  let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
  let x = match(encstring,"#",b:fencindex)
  let y = match(encstring,"#",x+1)
  let b:fencindex = x+1
  if y == -1
   let b:fencindex = 0
  else
   let str = strpart(encstring,x+1,y-x-1)
   return ":set fenc=".str
  endif
 endwhile
endfunction
