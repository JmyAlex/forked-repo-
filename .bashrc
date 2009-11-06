#!/bin/bash


############################################################################################################################################################
# Copyright (C) 2009 www.AskApache.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
############################################################################################################################################################


############################################################################################################################################################
# To install the latest version
#
# curl -O http://z.askapache.com/askapache-bash-profile.txt && source askapache-bash-profile.txt
# 
# To run automatically at login: In your ~/.bash_profile or similar login script do 
# [[ -r path-to-askapache-bash-profile.txt ]] && source path-to-askapache-bash-profile.txt
############################################################################################################################################################

# dont do anything for non-interactive shells
[[ -z "$PS1" && -z "$SSH_TTY" ]] && return
# trap -l
#  1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL
#  5) SIGTRAP      6) SIGABRT      7) SIGBUS       8) SIGFPE
#  9) SIGKILL     10) SIGUSR1     11) SIGSEGV     12) SIGUSR2
# 13) SIGPIPE     14) SIGALRM     15) SIGTERM     17) SIGCHLD
# 18) SIGCONT     19) SIGSTOP     20) SIGTSTP     21) SIGTTIN
# 22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
# 26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO
# 30) SIGPWR      31) SIGSYS      33) SIGRTMIN    34) SIGRTMIN+1
# 35) SIGRTMIN+2  36) SIGRTMIN+3  37) SIGRTMIN+4  38) SIGRTMIN+5
# 39) SIGRTMIN+6  40) SIGRTMIN+7  41) SIGRTMIN+8  42) SIGRTMIN+9
# 43) SIGRTMIN+10 44) SIGRTMIN+11 45) SIGRTMIN+12 46) SIGRTMIN+13
# 47) SIGRTMIN+14 48) SIGRTMIN+15 49) SIGRTMAX-15 50) SIGRTMAX-14
# 51) SIGRTMAX-13 52) SIGRTMAX-12 53) SIGRTMAX-11 54) SIGRTMAX-10
# 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7  58) SIGRTMAX-6
# 59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
# 63) SIGRTMAX-1  64) SIGRTMAX
trap 'e=$?; history -a; echo -e "\n!!! [$e] `kill -l $e` LINENO:$LINENO AFTER $SECONDS SECONDS !!!\n" | tee -a `tty 2>/dev/null`; ' 1 2 3 4 5 6 7 8 9 13 15

AAPN='AskApache Bash Profile Script'
AAPV='6.2'
AAPT='10/26/2009'
AAPS=`echo "$0" | sed -e 's,.*/,,'`


umask 0022



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell Limits
#------------------------------------------------------------------------------------------------------------------------------------------------------------
ulimit -S -c 0 # Don't want any coredumps



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell (set)tings
#------------------------------------------------------------------------------------------------------------------------------------------------------------
set +C +f +H +v +x +n -b -h -i -m -B
[[ $# -lt 1 && $1 == "debug" ]] && set -vx

#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell (shopt)ions
#------------------------------------------------------------------------------------------------------------------------------------------------------------
shopt -s histappend histreedit histverify cmdhist extglob dotglob checkwinsize progcomp sourcepath cdspell cdable_vars checkhash promptvars mailwarn
MAILCHECK=360

# quicker, cleaner ref
export N6=/dev/null


# if a program exists in path
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ahave()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  unset -v ahave;
  local type=$(command command type -a $1 &>$N6)
  command command type $1 &>$N6 && ahave="yes";
}


# Very cool
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function try_for_path()
{
  local GP=$HOME/bin:$HOME/sbin:$HOME/.gem/ruby/1.8/bin
  local P=$PATH:$HOME/libexec

  [[ "$EUID" -eq 0 ]] && P="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11"
  
  [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]] && export PATH="/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games"

  P=${P}:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games
  P=${P}:/bin:/etc:/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/bin/mh:/usr/libexec
  P=${P}:/usr/X11R6/bin:/usr/libexec:/etc/X11:/etc/X11/xinit
  P=${P}:/usr/local/dh/apache/template/bin:/usr/local/dh/apache2/template/bin
  P=${P}:/usr/local/dh/apache2/template/build:/usr/local/dh/apache2/template/sbin
  P=${P}:/usr/local/dh/bin:/usr/local/dh/java/bin:/usr/local/dh/java/jre/bin:/usr/local/php5/bin

  for p in ${P//:/ }; do [[ -d "${p}" && -x "${p}" ]] && GP=${GP}:$p; done;

  export PATH=$( echo -en "${GP//:/\\n}" | sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; h; P' | tr "\n" : ).;
}








#----------------------------
# CUSTOM SETTING VARIABLES
#----------------------------

[[ -f /etc/bashrc.bashrc ]] && . /etc/bashrc.bashrc
[[ -f /etc/bashrc ]] && . /etc/bashrc

# first set up path
try_for_path
[[ -z ${USER:=""} ]] && export USER=`whoami 2>$N6 || id -un 2>$N6 || logname 2>$N6`
[[ -z ${HOME:=""} ]] && export HOME=$(command pwd -L)

export GROUPNAME=`id -gn`
export HOME=${HOME:-~};
export SHELL=${SHELL:-/bin/bash}
ahave tty && export SSHTTY=`tty 2>$N6`

[[ "$DREAMHOST" == "yes" ]] && DREAMHOST=yes

# please use tzselect or tzconfig to set yours
[[ "$DREAMHOST" == "yes" ]] && export TZ=${TZ:-America/Indianapolis}

[[ -z "$HOSTNAME" ]] && export HOSTNAME=`hostname 2>$N6||uname -n 2>$N6`


[[ -d /tmp && -w /tmp ]] && export TMPDIR=${TMPDIR:-/tmp}



#----------------------------
# LIBS / COMPILES - EDIT 
#----------------------------
[[ "$DREAMHOST" == "yes" ]] && (
  export LDFLAGS="-L${HOME}/lib -L/lib -L/usr/lib -L/usr/lib/libc5-compat -L/lib/libc5-compat -L/usr/i486-linuxlibc1/lib -L/usr/X11R6/lib"
  export LD_LIBRARY_PATH=$HOME/lib
  export CPPFLAGS="-I${HOME}/include -I/usr/i486-linuxlibc1/include"
)



#----------------------------
# MAIL, PROGRAMS, EDITOR
#----------------------------
ahave nano && export EDITOR="`type -P nano`" && export VISUAL=$EDITOR
ahave lynx && export BROWSER="`type -P lynx`" && alias man='command man -H' && [[ -r $HOME/.lynx/lynx.cfg ]] && export LYNX_CFG=$HOME/.lynx/lynx.cfg;
ahave locate && [[ -r $HOME/var/locatedb ]] && export LOCATE_PATH=$HOME/var/locatedb && export LOCATE_DB=$HOME/var/locatedb




#setup paging
export PAGER=less
ahave lesspipe && (
  export LESSCHARSET='latin1'
  export LESSOPEN='|gzip -cdfq %s | `type -P lesspipe` %s 2>&-'
  export LESS='-i -N -w  -z-4 -e -M -X -J -s -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
  alias more='less'
)




#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function lesss()
{
  [[ $# -eq 0 ]] && command vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
  [[ $# -eq 0 ]] || command vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
}
ahave vim && [[ -r $HOME/.vimrc ]] && alias less='lesss'





#------------------------------------------------------------------------------------------------------------------------------------------------------------
# PROMPT
#------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# [10/19][user@host][~](1:580)
# $ 
#
export PS1="\n[`date +%m/%d`][\u@\h][\w]($SHLVL:\!)\n$ ";

COLORTERM=no; case ${TERM:-dummy} in linux*|con80*|con132*|console|xterm*|vt*|screen*|putty|Eterm|dtterm|ansi|rxvt|gnome*|*color*)COLORTERM=yes; ;; esac; export COLORTERM



# If set, the value is executed as a command prior to issuing each primary prompt.
ahave tty && export SSHTTY=$(tty 2>$N6);
[[ -z "$SSHTTY" ]] || export PROMPT_COMMAND='echo -ne "\033]0;$USER:`id -gn 2>$N6`@$HOSTNAME `tty 2>$N6`  [`uptime 2>$N6|sed -e "s/.*: \([^,]*\).*/\1/" -e "s/ //g"` / `command ps aux|wc -l`]  `command w|wc -l` users \007"'


# used by functions below
export RJ=0;
export L1=$(seq -s_ 1 75|tr -d [0-9]);
export L2=$(echo $L1|tr '_' ' ')





#---------------
# ls aliases
#---------------
[[ "$COLORTERM" == "yes" ]] && C=' --color=auto' || C=;
alias la="command ls -Al${C}"      # show hidden files
alias lx="command ls -lAXB${C}"    # sort by extension
alias lk="command ls -lASr${C}"    # sort by size
alias lc="command ls -lAcr${C}"    # sort by change time
alias lu="command ls -lAur${C}"    # sort by access time
alias lr="command ls -lAR${C}"     # recursive ls
alias lt="command ls -lAtr${C}"    # sort by date
alias lll="stat -c %a\ %N\ %G\ %U \$PWD/*|sort"



#---------------
# safety aliases
#---------------
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function safe_shell_aliases()
{
  [[ `command type -t mymv` == "alias" ]] && for fa in "chmod" "mkdir" "rm" "cp" "mv" "mymv"; do unalias $fa; done && return;
  alias chmod='command chmod -c'
  alias mkdir='command mkdir -pv'
  alias rm='command rm -v'
  alias cp='command cp -v'
  alias mv='command mv -v'
  alias mymv='echo'
}
[[ "$EUID" -eq 0 ]] && safe_shell_aliases;



#---------------
# func aliases
#---------------
[[ -r ${HOME}/etc/ld.so.conf && -r ${HOME}/etc/ld.so.cache ]] && alias ldconfig="ldconfig -v -f ${HOME}/etc/ld.so.conf -C ${HOME}/etc/ld.so.cache"
[[ "$UNAME" != "Linux" ]] && ahave gsed && alias sed=gsed

alias who='command who -ar -pld'
ahave which || alias which='command type -path'
ahave tree || alias tree='command ls -FR'
ahave tree && alias tree='command tree -Csuflapi'

alias top='top -c'  #command top -d 1 -u $USER
ahave vim && alias vim='command vim --noplugin'
alias du='command du -kh'
alias du1='echo *|tr " " "\n" |xargs -iFF command du -hs FF|sort'

alias df='command df -kTh'
alias path='echo -e ${PATH//:/\\n}'

alias php='php -d report_memleaks=1 -d report_zend_debug=1 -d log_errors=0 -d ignore_repeated_errors=0 -d ignore_repeated_source=0 -d error_reporting=30719 -d display_startup_errors=1 -d display_errors=1'
#alias man='man -H'

alias pp='command ps -HAcl -F S -A f'
alias p='command ps -HAcl -F S -A f|uniq -w3'
alias ps2='command ps -H'
alias ps1='command ps -lFA'

alias df1='command df -iTa'
alias n="${EDITOR}"3
alias inice='ionice -c3 -n7 nice'
alias vdir="ls --format=long"
alias dir="ls --format=vertical"
alias killphp='pkill -9 -f php.cgi\|php5.cgi\|php-cgi\|php\|php4.cgi;pkill -13 -f php.cgi\|php5.cgi\|php-cgi\|php\|php4.cgi'
alias dsiz='du -sk * | sort -n --'
alias h='history'
alias j='jobs -l'
alias ..='cd ..'
alias wtf='watch -n 1 w -hs'

ahave ccze && alias lessc='ccze -A |`type -P less` -R'


#---------------
# spelling typos
#---------------
alias kk='ll'
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
















###########################################################################--=--=--=--=--=--=--=--=--=--=--#
###
### FUNCTIONS
###
###########################################################################==-==-==-==-==-==-==-==-==-==-==#
#sed '/./=' ~/.bash_profile | sed '/./N; s/\n/ /'
#sed = ~/.bash_profile |sed 'N; s/^/     /; s/ *\(.\{6,\}\)\n/\1  /'
ahave tput && export SMSO=$(tput smso &>$N6);export RMSO=$(tput rmso &>$N6);
#find . -type f -iname '*htaccess*' -print0 | xargs -0 grep -sn -i "THE_REQUEST" | sed "s/THE_REQUEST/${SMSO}\0$RMSO}/gI"

#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function centerit() 
{ echo "$@" | awk '
{ spaces = ('$COLUMNS' - length) / 2
  while (spaces-- > 0) printf (" ")
  print
}'
}


function wcdir()
{  
  echo *|tr ' ' "\n" |xargs -iFF sh -c 'test -d FF && echo `find FF/ -type f 2>/dev/null |wc -l; echo FF`'|sort -n
}

#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function locate1()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  command locate "$@" | xargs -iFF stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N FF ;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function asetup_colors()
{
  [[ "$COLORTERM" == "no" ]] && return;
  ahave dircolors && eval "`dircolors -b`"

  export PS1="\n[`date +%m/%d`]\e[1;37m[\e[0;32m\u\e[0;35m@\e[0;32m\h\e[1;37m][\e[0;31m\w\e[1;37m]($SHLVL:\!)\n\[${R}\]\$ " || PS1=PS1="\n[`date +%m/%d`][\u@\h][\w]($SHLVL:\!)\n\[\]\$ "

  [[ -r $HOME/.dircolors ]] && eval "`dircolors $HOME/.dircolors`" && return;

  [[ ! -f $HOME/.dircolors ]] && dircolors --print-database > $HOME/.dircolors
  local L="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31"
  L="${L}:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31"
  L="${L}:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35"
  L="${L}:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35"
  L="${L}:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.cpio=01;31"
  export LS_COLORS="${L}:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.htaccess=01;31:*.htpasswd=01;31:*.htpasswda1=01;31:*config.php=01;31:*wp-config.php=01;31:";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function diffdirs ()
{
  [[ "$#" -lt "2" ]] && echo "Usage: $FUNCNAME dir1 dir2" >&2 && exit 1
  ahave colordiff && colordiff -urp -w $1 $2;
}

# 30 - Black, 31 - Red, 32 - Green, 33 - Yellow, 34 - Blue, 35 - Magenta, 36 - Blue/Green, 37 - White, 30/42 - Black on Green '30\;42'
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function create_colors()
{
  for i in `seq 0 7`;do ii=$(($i+7));CC[$i]="\033[1;3${i}m";CC[$ii]="\033[0;3${i}m";done;CC[15]="\033[30;42m"; export R=$'\033[0;00m';export X=$'\033[1;37m'; export CC;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function test_colors()
{
  echo -e "$R"; ahave tput && tput sgr0; for ((i=0; i<=${#CC[@]} - 1; i++)); do echo -e "${CC[$i]}[$i]\n$R"; done;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function show_all_colors()
{
  local a b c x y z s o q; x=8;y=6;z=36;o=0;q=`seq 0 5`;
  for a in `seq 0 7`;do for b in {0,1}; do s=`echo "$o + $x * ${b} + $a" | bc`; echo -en "\E[0;48;5;${s}m color [$o+$x+$b+$a] ${s} \E[0m"; done;echo;done
  o=16;for a in $q;do for b in $q;do for c in $q; do s=`echo "$o + $y * ${c} + $b + $z * ${a}" | bc`; echo -en "\E[0;48;5;${s}m color [$o+$y+$c+$b+$z*$a] ${s} \E[0m";done;echo;done;done
  o=232;for a in `seq 0 23`; do s=`expr $o + $a`; echo -en "\E[0;48;5;${s}m ${s}\E[0m";done;echo
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function clean_exit()
{
  lin 0;lin 1;lin 2 "COMPLETED SUCCESSFULLY";lin 1;lin 3;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function dirty_exit()
{
  echo "See ya..";sleep 1;exit;
}


# get_latest_revision
# 1 - URL of repository - Defaults to http://svn.automattic.com/wordpress/trunk
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_latest_revision()
{
  local URL=${1:-http://svn.automattic.com/wordpress/trunk}; svn info $URL | grep ^Rev|sed -e 's/Revision: \([0-9]*\)/\1/g';
}


# get_crypt_user
#
# Get encryption user to use for encryption/decryption
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_crypt_user()
{
  local U=`gpg --list-keys|sed -e '/^uid /!d' -e 's/^uid[ ]*\(.*\)/\1/g'` || unknown; [[ $# -ne 0 ]] && U=${U//\<*}; echo -n $U;
}







# get_random_under 180 - echos a random number between 1 and 180
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_random_under()
{
  echo $(( $RANDOM % ${1:-$RANDOM} + 1 ));
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function uniqf()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  awk '!($0 in a) {a[$0];print}' "$1";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function sleeper()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  echo -en "\n${2:-.}"; while `command ps -p $1 &>$N6`; do echo -n "${2:-.}"; sleep ${3:-1}; done; echo;
};


#
# FROM:  http://tldp.org/LDP/abs/html/
#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function aa_isalpha ()   # Tests whether *entire string* is alphabetic.
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME str" >&2 && exit 1
  case $1 in *[!a-zA-Z]*|"") return -1; ;; *) return 0; ;; esac;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function aa_isdigit ()    # Tests whether *entire string* is numerical integer variable.
{ case $1 in *[!0-9]*|"") return -1; ;; *) return 0; ;; esac;
}

#
# http://tldp.org/LDP/abs/html/loops1.html#SYMLINKS
#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function find_symlinks()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local O=$IFS;IFS='';for file in "$( find ${1:-`pwd`} -type l )"; do echo "$file"; done | sort;
} # Null IFS means no word breaks  


#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function arepeat()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local i max=$1; shift; for ((i=1; i <= max ; i++)); do eval "$@"; done;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function cuttail()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  sed -n -e :a -e "1,${2:-10}!{P;N;D;};N;ba" $1;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function quote()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  echo \'${1//\'/\'\\\'\'}\';
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function dequote()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  eval echo "$1";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_pids_on_system()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  command ps axo pid|sed 1d;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_pgids_on_system()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  command ps axo pgid|sed 1d;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_users_on_system()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  ahave getent &>$N6 && getent passwd|awk -F: '{print $1}' && return; awk 'BEGIN {FS=":"} {print $1}' /etc/passwd;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_groups_on_system()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  ahave getent &>$N6 && getent group|awk -F: '{print $1}' && return; awk 'BEGIN {FS=":"} {print $1}' /etc/group;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function get_inet_interface_ips()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  ahave ip && ip -o -f inet addr|sed -e '/inet 10./d' -e 's/\/24//g' |awk '{print $4}'|sed -e "s/\\n//g" -e '/.*\.0$/d';
}

#
# http://tldp.org/LDP/abs/html/asciitable.html#ASCIISH
#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function print_ascii_chart()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local p pp o i=1;o=1;while [[ $i -lt 256 ]];do p="    $i";echo -n "${p: -5}  ";pp="00$o";echo -e "\\0${pp: -3}";((i++,o++));((i % 8 == 0))&&((o+=2));((i % 64 == 0))&&((o+=20));done|cat -t;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function wget()
{
  local wgetrc=${1:-$HOME/.wgetrc}
  local settings='header = Accept-Language: en-us,en;q=0.5\nheader = Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
  settings='${settings}\nheader = Accept-Encoding: gzip,deflate'
  settings='${settings}\nheader = Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7'
  settings='${settings}\nheader = Keep-Alive: 300'
  settings='${settings}\nuser_agent = Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3'
  settings='${settings}\nreferer = http://www.google.com'
  settings='${settings}\nrobots = off'
  [[ ! -f $wgetrc ]] && echo -e "$settings" > $wgetrc || echo -e "$settings" >> $wgetrc
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function aa_mkdir()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65

  local e=0; for f in ${1+"$@"};do set fnord `echo ":$f"|sed -e 's/^:\//%/' -e 's/^://' -e 's/\// /g' -e 's/^%/\//'`;shift;p=;for d in ${1+"$@"};do p="$p$d";
  case "$p" in -*)p=./$p; ;; ?:)p="$p/";continue ;; esac; [[ ! -d "$p" ]] && mkdir -v "$p"||e=$?;p="$p/";done;done;return $e;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function set_window_title()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  echo -n -e "\033]0;$*\007";
}




# pd
#
# Prints message notifying user of end of the current task
# 1 - Text - Defaults to DONE
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function pd()
{
  echo -e  "\n ${CC[15]} ${1:-DONE} $R\n\n" >$SSHTTY;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function cont()
{
  local ans; echo -en "\n ${CC[15]}[ ${1:-Press any key to continue} ]$R\n"; read -n 1 ans; beep_alarm 1;
}


# do_sleep
#
# Sleeps until global process PID $RJ does not exist
# 1
# 2 - Length of pause between output
# 3 - Character to show progress - Defaults to .
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function do_sleep ()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local E D; echo -en "${CC[6]}${3:-.}" >$SSHTTY; while `command ps -p $RJ &>$N6`; do sleep ${2:-3}; echo -en "${3:-.}" >$SSHTTY; done; echo -e "${CC[0]}" >$SSHTTY && sleep 1 && pd;
}





#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function pm()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local I=${1:-3};
  echo -en "$R\n"; #tm 0;
  local S=$SSHTTY;
    case ${2:-1} in
     0) echo -en "${CC[6]}-- $X$R" >$S;  ;;
     1) echo -e  "${CC[2]}>>> $X$I$R" >$S; ;;
     2) echo -en  "${CC[4]} > $X$I$R" >$S; ;;
     3) echo -e  "${CC[4]} :: $X$I$R" >$S; ;;
    esac;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function yes_no()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local a YN=65; echo -en "${1:-Answer} [y/n] "; read -n 1 a; case $a in [yY]) YN=0; ;; esac; return $YN;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function yn()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local a YN=N; echo -en "\n ${CC[6]}@@ ${1:-Q} $R$X[y/N] $R">$SSHTTY; read -n 1 a; case $a in [yY]) YN=Y; ;; esac; echo >$SSHTTY; echo -en $YN;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function lin()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
 
  case ${1:-1} in
    0) echo -e "\n ${CC[0]}$L1"; ;;
  1) echo -e "${CC[0]}|${CC[34]}$L2${CC[0]}|"; ;;
  2) echo -en "${CC[0]}|${CC[34]}"; echo -en "${2:-1}" | sed -e :a -e 's/^.\{1,72\}$/ & /;ta' -e "s/\(.*\)/\1/";   echo -e "${CC[0]} |";
     ;;
  3) echo -e "${CC[0]} $L1 $R$X\n\n"; ;;
  esac;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function pwd()
{
  command pwd -LP "$@";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function kill_jobs()
{
  for i in `jobs -p`; do kill -9 $i; done;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function beep_alarm()
{
  local i; for i in `seq 1 ${1:-5}`;do echo -en "\a" && sleep 1; done;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function mp3info()
{
  ls *.mp3 |xargs -ix 2>&1 ffmpeg -i x|grep -v "^Must" |grep -v "built\|libavutil\|libavcodec\|configuration\|FFmpeg\|libavformat";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function tailit()
{
  clear;echo "p e a ma md all | FILENAME"; sh ${HOME}/scripts/logview.sh "${2:-askapache.com}" "${1:-all}";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function l()
{
  command ls -AhFp --color=auto "$@";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function la()
{
  du *|awk '{print $2,$1}'|sort -n|tr ' ' "\t";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ll()
{
  command ls -lABls1c --color=auto "$@";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function getsrc()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  local URL=$1; local FB=`basename $URL`; local OD=`pwd -L`; cd ~/source; curl -o ~/dist/$FB $URL && tar -xvzf ~/dist/$FB; cd $OD;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function stat1()
{
  local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/ [0-9:]\{8\}\.[0-9]\{9\} -[0-9]\+//g' |tr  -d "\`\'"|sort -r;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function stat2()
{
  local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/\.[0-9]\{9\} -[0-9]\+//g'|tr  -d "\`\'"|sort -r;
}





#--=--=--=--=--=--=--=--=--=--=--#
# processes
#==-==-==-==-==-==-==-==-==-==-==#

#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function psu()
{
  command ps -Hcl -F S f -u ${1:-$USER};
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ps()
{
  [[ -z "$1" ]] && command ps -Hacl -F S -A f && return; command ps "$@";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function make_nice()
{
  ahave nice || return; pm "Making Nice $$"; pm 0 0; command renice ${1:-19} -p $$; pd;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function make_ionice()
{
  ahave ionice || return; pm "Making IONice $$"; pm 0 0; command ionice -c${1:-3} -n7 -p $$; pd;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function dump_ps_environment() 
{
  command ps aux | grep ${USER:0:3} | awk '{print $2}' | xargs -t -ipid cat /proc/pid/environ 2>$N6;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function procinfo1()
{
  PI=($(strace -s1 procinfo -a 2>&1|sed -e '/^op/!d' -e '/pro/!d' -e '/= -1/d'|sed -e 's%o.*"/proc/\(.*\)".*% \1%g')); for i in ${PI[*]}; do echo -e "\n---===[  /proc/$i  ]\n" && cat /proc/$i && echo -e "\n\n"; done;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function pss(){
  local U PPS PL PX PXX UUS=( $(command ps uax|awk '{print $1}'|command tail -n +2|sort|uniq) ); UL=$((${#UUS[@]} - 1))
  exec 6>&1; exec > ~/proc.$$
  ps aux | grep ${USER:0:3} | awk '{print $2}' | xargs -t -ipid cat /proc/pid/environ
  for UX in $(seq 0 1 $UUS); do U=${UUS[$UX]}; PPS=( $(pgrep -u ${U}) ); PL=$((${#PPS[@]} - 1));
   for PX in $(seq 0 1 $PL); do PXX=${PPS[$PX]};echo -e "\n\n\n----- PROCESS ID: ${PXX} -----\n\n";cat /proc/${PXX}/cmdline 2>$N6 || echo;echo -e "\n\n"; command tree -Csuflapi /proc/Q/${PXX};done
  done
  exec 1>&6 6>&-; cat ~/proc.$$ | more
}





#------------------------------------------------------------------------------------------------------------------------------------------------------------
# history setup
#------------------------------------------------------------------------------------------------------------------------------------------------------------

#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function uniq2() 
{ [[ -f "$1" ]] && sed = $1 | sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P';
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function asetup_history()
{

  [[ "$SHLVL" -gt "1" ]] && return
  HISTCONTROL=${HISTCONTROL:-'ignoreboth'};
  HISTTIMEFORMAT="%H:%M > "
  HISTIGNORE='clear*:ll:ls:ps:updatedb*:top*:h2*:h1*:h3*:hpopular*:history*:dir:date*:export:env:exit'
  HISTSIZE=5000
  HISTFILESIZE=50000
  export HISTCONTROL HISTIGNORE HISTSIZE HISTFILESIZE HISTTIMEFORMAT
  
  export HISTFILE=${HISTFILE:-$HOME/.bash_history}
  [[ ! -r ${HISTFILE} ]] && (
    history -a $HISTFILE
    history -c
    history -r $HISTFILE
  )
 
  
  HISTFILEMASTER=${HISTFILEMASTER:-$HOME/backups/.history/combined.log};
  [[ ! -d "`dirname ${HISTFILEMASTER}`" ]] && mkdir -pv `dirname ${HISTFILEMASTER}` && history -a $HISTFILEMASTER
 
  [[ ! -f ${HISTFILEMASTER} ]] && history -a && history -c && history -r
  
  HISTFILEMASTER_C=`dirname ${HISTFILEMASTER}`/combined-uniq.log;
  export HISTFILEMASTER HISTFILE HISTFILEMASTER_C
    
  history -a $HISTFILEMASTER_C
  
  [[ "`cat $HISTFILEMASTER_C | wc -l`" -gt "$HISTFILESIZE" ]] && mv -v $HISTFILEMASTER_C `date +$HISTFILEMASTER_C-%m-%d-%y` && echo "" > $HISTFILEMASTER_C
  [[ "`cat $HISTFILEMASTER | wc -l`" -gt "$HISTFILESIZE" ]] && mv -v $HISTFILEMASTER `date +$HISTFILEMASTER-%m-%d-%y` && echo "" > $HISTFILEMASTER
  [[ "`cat $HISTFILE | wc -l`" -gt "$HISTFILESIZE" ]] && mv -v $HISTFILE `date +$HISTFILE%m-%d-%y` && echo "" > $HISTFILE


  [[ $SHLVL -eq 1 ]] && cat $HISTFILE $HISTFILEMASTER >> $HISTFILEMASTER_C && ahave nice && nice -n 19 sed -i -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P' $HISTFILEMASTER_C &
  
  [[ $SHLVL -eq 1 ]] && eval $(echo "sh -c 'cd `dirname ${HISTFILEMASTER}`; echo *|tr \" \" \"\n\"|xargs -iFF sed -i -e \"s/^[ \t]*//;s/[ \t]*$//\" FF && echo *|tr \" \" \"\n\"|xargs -iFF sed -i -e \"/./!d\" FF && echo *|tr \" \" \"\n\"|xargs -iFF sed -i -n \"/^.\{10\}/p\" FF'" ) &>$N6 & &>$N6

  
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function h1()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  history -a; cat $HISTFILEMASTER $HISTFILE | command grep "$@" | sort | uniq | command grep --color=always $1;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function h2()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  history -a; command grep -h -r -i "$@" `dirname $HISTFILEMASTER` | uniq;
}
function h2c()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  history -a; command grep -h -r --color=always -i "$@" `dirname $HISTFILEMASTER` | uniq;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function h3()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  history -a $HISTFILEMASTER_C; command grep "$@" `dirname $HISTFILEMASTER`/combined*;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function hpopular()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  history -a; cat $HISTFILEMASTER $HISTFILE | awk '{print $2}' | sort | uniq -c | sort -rn | head -n ${1:-50};
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function rmb()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  command rm -rf "$1" 2>&1 &>$N6 & 2>&1 &>$N6; echo -n &>$N6;
}


# nohup - run command detached from terminal and without output
# usage: nh <command>
nh()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65
  nohup "$@" &>$N6 & echo;
}


#[[ "$1" == *.tbz -o "$1" == *.bz -o "$1" == *.bzip -o "$1" == *.bz2 ]] && bzip=yes
#[[ "$1" == *.tbz -o "$1" == *.tgz -o "$1" == *.tar* -o "$1" == *.bz2 ]] && bzip=yes


ex ()
{
   [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >&2 && exit 65

  [[ -f "$1" ]] || echo "'$1' is not a valid file" && return 1;
  *.tgz
  *.tbz
  *.
     case "$1" in *.tar.bz2)   tar xjf $1   ;;
       *.tar.gz)    tar xzf $1   ;;
       *.bz2)       bunzip2 $1   ;;
       *.rar)       rar x $1     ;;
       *.gz)        gunzip $1    ;;
       *.tar)       tar xf $1    ;;
       *.tbz2)      tar xjf $1   ;;
       *.tgz)       tar xzf $1   ;;
       *.zip)       unzip $1     ;;
       *.Z)         uncompress $1;;
       *.7z)        7z x $1      ;;
       *)           echo "'$1' cannot be extracted via ex()" ;;
     esac
}

function dos2unixx()
{
 [[ $# -eq 0 ]] && exec tr -d '\015\032' || [[ ! -f "$1" ]] && echo "Not found: $1" && return

  es=1
  for f in "$@" ; do
   if tr -d '\015\032' < "$f" > "$f.tmp" ; then
     if cmp "$f" "$f.tmp" >/dev/null ; then
       rm -f "$f.tmp"
     else
       touch -r "$f" "$f.tmp"
       if mv "$f" "$f.bak" ; then
         if mv "$f.tmp" "$f" ; then
           rm -f "$f.bak" && es=$? && echo "  converted $f"
         else
           rm -f "$f.tmp"
         fi
       else
         rm -f "$f.tmp"
       fi
     fi
   else
     rm -f "$f.tmp"
   fi
  done
  return $es
}


#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ascript_title()
{
   #created with figlet
   clear; echo; echo; date +%c\ %Z; lin 0;
   echo -e "| ${CC[2]}                ___       __    ___                 __                  ${CC[0]} |"
   echo -e "| ${CC[2]}               / _ | ___ / /__ / _ | ___  ___ _____/ /  ___             ${CC[0]} |"
   echo -e "| ${CC[9]}              / __ |(_-</  '_// __ |/ _ \/ _ \`/ __/ _ \/ -_)            ${CC[0]} |"
   echo -e "| ${CC[9]}             /_/ |_/___/_/\_\/_/ |_/ .__/\_,_/\__/_//_/\__/             ${CC[0]} |"
   echo -e "| ${CC[9]}                                  /_/                                   ${CC[0]} |";
   lin 1; lin 2 "${1:-$AAPN}"; lin 2 "Version ${2:-$AAPV} - Build: ${3:-$AAPT}"; lin 3;
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ashow_motd()
{
  [[ -r /etc/motd ]] && echo -e "\n\n${CC[2]}`head -n 7 /etc/motd | tail -n 6`${R}\n";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ashow_calendar()
{
  [[ -d /usr/share/calendar/ ]] && echo -en "\n${CC[5]}" && ( sed = $(echo /usr/share/calendar/calendar*) | sed -n "/$(date +%m\\/%d\\\|%b\*\ %d)/p" ) && echo -en "${R}";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function ashow_fortune()
{
  [[ -x `type -P fortune` ]] && echo -en "\n${CC[6]}" && `type -P fortune` -s && echo -en "${R}";
}



#--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--#
function askapache()
{
  ascript_title && ashow_motd

  ahave who && pm "Users" && pm "Logged In" 3; command who -ar -pld && pm "Current Limits" 3;command ulimit -a

  pm "Machine stats"; ahave uptime && pm "uptime" 3 && command uptime; [[ -d /proc ]] && [[ -f /proc/meminfo ]] && cat /proc/meminfo
  ahave who && pm "Users" 3 && command who
  
  pm "Networking"
  ahave ip && pm "interfaces" 3 && ip -o addr|sed -e 's/ \{1,\}/\t/g'
  [[ -r /proc/net/sockstat ]] && pm "Sockets" 3 && head -n 2 /proc/net/sockstat
  ahave ss && pm "Networking Stats" 3 && ss -s; ahave netstat && pm "Routing Information" 3 && netstat -r

  pm "Disk"; pm "Mounts" 3; command df -hai
  #[[ -d /sys/block/ ]] && pm "IO Scheduling" 3; for d in /sys/block/[a-z][a-z][a-z]*/queue/*; do [[ -d $d ]] && tree $d; echo "$d => $(cat $d)";done
  ahave iostat && pm "I/O on Disks" && iostat -p ALL

  pm "Processes"; pm "process tree" 3;  command ps -HAcl -F S -A f | uniq -w3
  ahave procinfo && pm "procinfo" 3 && procinfo|head -n 13|tail -n 11
  
  procinfo1
}









###########################################################################--=--=--=--=--=--=--=--=--=--=--#
###
###  MAIN - Runs on exec
###
###########################################################################--=--=--=--=--=--=--=--=--=--=--#
create_colors
asetup_colors && asetup_history

#change that window title on login -- the G235 is a temp hack
G235=$( echo -ne "\033]0;`id -un`:`id -gn`@`hostname||uname -n|sed 1q` `who -m|sed -e "s%^.* \(pts/[0-9]*\).*(\(.*\))%[\1] (\2)%g"` [`uptime|sed -e "s/.*: \([^,]*\).*/\1/" -e "s/ //g"` / `ps aux|wc -l`]\007"||echo );
#because now we can do:
echo $G235

# temp hack for being able to source all the functions in this file from a script
[[ $SHLVL -lt 2 ]] && askapache || return


#[[ -f /etc/bash_completion ]] && . /etc/bash_completion
















#       gzip [ -acdfhlLnNrtvV19 ] [-S suffix] [ name ...  ]
#       gunzip [ -acfhlLnNrtvV ] [-S suffix] [ name ...  ]
#       zcat [ -fhLV ] [ name ...  ]
#
#       gunzip  takes a list of files on its command line and replaces each file whose name ends with .gz, -gz, .z, -z, _z or .Z and which begins with the correct magic number with an uncompressed
#       file without the original extension.  gunzip also recognizes the special extensions .tgz and .taz as shorthands for .tar.gz and .tar.Z respectively.  When compressing, gzip uses  the  .tgz
#       extension if necessary instead of truncating a file with a .tar extension.
#
#       zcat  is identical to gunzip -c.  (On some systems, zcat may be installed as gzcat to preserve the original link to compress.)  zcat uncompresses either a list of files on the command line
#       or its standard input and writes the uncompressed data on standard output.  zcat will uncompress files that have the correct magic number whether they have a .gz suffix or not.
#       -l --list
#              The uncompressed size is given as -1 for files not in gzip format, such as compressed .Z files. To get the uncompressed size for such a file, you can use:
#                  zcat file.Z | wc -c
#
#              The compression methods currently supported are deflate, compress, lzh (SCO compress -H) and pack.  The crc is given as ffffffff for a file not in gzip format.
#              With --verbose, the size totals and compression ratio for all files is also displayed, unless some sizes are unknown. With --quiet, the title and totals lines are not displayed.
#       -r --recursive
#              Travel the directory structure recursively. If any of the file names specified on the command line are directories, gzip will descend into the directory and compress all  the  files
#              it finds there (or decompress them in the case of gunzip ).
#       If you want to recompress concatenated files to get better compression, do:
#             gzip -cd old.gz | gzip > new.gz

#       If a compressed file consists of several members, the uncompressed size and CRC reported by the --list option applies to the last member only. If you need the  uncompressed  size  for  all
#       members, you can use:
#             gzip -cd file.gz | wc -c






#   Note that the order of redirections is significant. For example, the command
#   ls > dirlist 2>&1
#   directs both standard output and standard error to the file dirlist, while the command
#
#   ls 2>&1 > dirlist
#   directs only the standard output to file dirlist, because the standard error was duplicated as standard output before the standard output was redirected to dirlist.




#------------------------------------------------------------------------------------------------------------------------------------------------------------
# personalized colors
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Attribute codes:    00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:   30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes: 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
# NORMAL 00       # global default, although everything should be something.
# FILE 00         # normal file
# DIR 01;34       # directory
# LINK 01;36      # symbolic link.
# FIFO 40;33      # pipe
# SOCK 01;35      # socket
# DOOR 01;35      # door
# BLK 40;33;01    # block device driver
# CHR 40;33;01    # character device driver
# ORPHAN 40;31;01 # symlink to nonexistent file
# EXEC 01;32      # executables
#------------------------------------------------------------------------------------------------------------------------------------------------------------



# Advanced Shell Limits
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# -S      use the `soft' resource limit
# -H      use the `hard' resource limit
# -a      all current limits are reported
# -c      the maximum size of core files created
# -d      the maximum size of a process's data segment
# -f      the maximum size of files created by the shell
# -l      the maximum size a process may lock into memory
# -m      the maximum resident set size
# -n      the maximum number of open file descriptors
# -p      the pipe buffer size
# -s      the maximum stack size
# -t      the maximum amount of cpu time in seconds
# -u      the maximum number of user processes
# -v      the size of v
# [see man getrlimit, help ulimit]
#------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Trapping Signals to Catch Errors
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# The first digit selects the set user ID (4) and set group ID (2) and sticky (1) attributes.
# The second digit selects permissions for the user who owns the file: read (4), write (2), and execute (1)
# The third selects permissions for other users in the file's group, with the same values
# The fourth for other users not in the file's group, with the same values.
# [see man chmod, help umask]
#------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1      2      3       4      5       6       7      8      9       10      11      12      13      14      15      17      18      19      20      21
# SIGHUP SIGINT SIGQUIT SIGILL SIGTRAP SIGABRT SIGBUS SIGFPE SIGKILL SIGUSR1 SIGSEGV SIGUSR2 SIGPIPE SIGALRM SIGTERM SIGCHLD SIGCONT SIGSTOP SIGTSTP SIGTTIN 
# [see man bash, man signal, help trap]
#------------------------------------------------------------------------------------------------------------------------------------------------------------



# http://tldp.org/LDP/abs/html/sample-bashrc.html
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# e [errexit]     Exit immediately if a command exits with a non-zero status.
# B [braceexpand] The shell will perform brace expansion.
# h [hashall]     Remember the location of commands as they
# f [noglob]      Disable file name generation (globbing).
# H [histexpand]  Enable ! style history substitution.
# v [verbose]     Print shell input lines as they are read.
# x [xtrace]      Print commands and their arguments as they are executed.
# n [noexec]      Read commands but do not execute them.
#   [history]       Enable command history
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# [see man bash, help set]
# cdable_vars   an argument to the cd builtin command that is not a directory is assumed to be the name of a variable dir to change to.
# cdspell     minor errors in the spelling of a directory component in a cd command will be corrected.  
# checkhash     bash checks that a command found in the hash table exists before execute it.  If no longer exists, a path search is performed.
# checkwinsize    bash checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS.
# cmdhist     bash attempts to save all lines of a multiple-line command in the same history entry.  Allows re-editing of multi-line commands.
# dotglob     bash includes filenames beginning with a `.' in the results of pathname expansion.
# execfail      a non-int shell will not exit if it cannot execute the file specified as an argument to the exec builtin command, like int sh.
# expand_aliases  aliases are expanded as described above under ALIASES.  This option is enabled by default for interactive shells.
# extglob       the extended pattern matching features described above under Pathname Expansion are enabled.
# histappend    the history list is appended to the file named by the value of the HISTFILE variable when shell exits, no overwriting the file.
# hostcomplete    and readline is being used, bash will attempt to perform hostname completion when a word containing a @ is being completed
# huponexit     bash will send SIGHUP to all jobs when an interactive login shell exits.
# interactive_comments    allow a word beginning with # to cause that word and all remaining characters on that line to be ignored in an interactive shell
# lithist       if cmdhist option is enabled, multi-line commands are saved to the history with embedded newlines rather than using semicolon
# login_shell     shell sets this option if it is started as a login shell (see INVOCATION above).  The value may not be changed.
# mailwarn        file that bash is checking for mail has been accessed since the last checked, ``The mail in mailfile has been read'' is displayed.
# no_empty_cmd_completion bash will not attempt to search the PATH for possible completions when completion is attempted on an empty line.
# nocaseglob    bash matches filenames in a case-insensitive fashion when performing pathname expansion (see Pathname Expansion above).
# nullglob      bash allows patterns which match no files (see Pathname Expansion above) to expand to a null string, rather than themselves.
# progcomp      the programmable completion facilities (see Programmable Completion above) are enabled.  This option is enabled by default.
# promptvars    prompt strings undergo variable and parameter expansion after being expanded as described in PROMPTING above.  
# shift_verbose   the shift builtin prints an error message when the shift count exceeds the number of positional parameters.
# sourcepath    the source (.) builtin uses the value of PATH to find the directory containing the file supplied as an argument.
# xpg_echo      the echo builtin expands backslash-escape sequences by default.
# [see man bash, help shopt]
#------------------------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------------------------
# \a     an ASCII bell character (07)
# \d     the date in "Weekday Month Date" format (e.g., "Tue May 26")
# \D{format}  the format is passed to strftime(3) and the result is inserted into the prompt string;
# \e     an ASCII escape character (033)
# \h     the hostname up to the first `.'
# \H     the hostname
# \j     the number of jobs currently managed by the shell
# \l     the basename of the shell's terminal device name
# \n     newline
# \r     carriage return
# \s     the name of the shell, the basename of $0 (the portion following the final slash)
# \t     the current time in 24-hour HH:MM:SS format
# \T     the current time in 12-hour HH:MM:SS format
# \@     the current time in 12-hour am/pm format
# \A     the current time in 24-hour HH:MM format
# \u     the username of the current user
# \v     the version of bash (e.g., 2.00)
# \V     the release of bash, version + patchelvel (e.g., 2.00.0)
# \w     the current working directory
# \W     the basename of the current working directory
# \!     the history number of this command
# \#     the command number of this command
# \$     if the effective UID is 0, a #, otherwise a $
# \nnn   the character corresponding to the octal number nnn
# \\     a backslash
# \[     begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt
# \]     end a sequence of non-printing characters
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# HISTCONTROL
#    If  set  to a value of ignorespace, lines which begin with a space character are not entered on the history list.  
#    If set to a value of ignoredups, lines matching the last history line are not entered.  A value of ignoreboth combines the two options.
#    If unset, or if set to any other value than those above, all lines read by the parser are saved on the history list, subject to the value of HISTIGNORE.  
# HISTFILE
#    The name of the file in which command history is saved (see HISTORY below).  The default value is ~/.bash_history.  If unset, the command history is not saved when an interactive shell exits.
# HISTFILESIZE
#    The  maximum number of lines contained in the history file.  When this variable is assigned a value, the history file is truncated, if necessary, to contain no more than that number of lines.  
#    The default value is 500.  The history file is also trun-cated to this size after writing it when an interactive shell exits.
# HISTIGNORE
#    A colon-separated list of patterns used to decide which command lines should be saved on the history list.  Each pattern is anchored at the beginning of the line and must match the complete line (no implicit `*' is appended).
#    Each pattern is  tested against  the  line  after  the  checks  specified  by HISTCONTROL are applied.  In addition to the normal shell pattern matching characters, `&' matches the previous history line.  
#    `&' may be escaped using a backslash; the backslash is removed before attempting a match.  The second and subsequent lines of a multi-line compound command are not tested, and are added to the history regardless of the value of HISTIGNORE.
# HISTSIZE
#    The number of commands to remember in the command history (see HISTORY below).  The default value is 500.
#
#------------------------------------------------------------------------------------------------------------------------------------------------------------



############################################################################################################################################################
# bash defines the following built-in commands: 
#   :, ., [, alias, bg, bind, break, builtin, case, cd, command, compgen, complete, continue, declare, dirs
#   disown, echo, enable, eval, exec, exit, export, fc, fg, getopts, hash, help, history, if, jobs, kill,
#   let, local, logout, popd, printf, pushd, pwd, read, readonly, return, set, shift, shopt, source, suspend
#   test, times, trap, type, typeset, ulimit, umask, unalias, unset, until, wait, while



# Connectives for `test'
# ! EXPR  -  True if EXPR is false.
# EXPR1 -a EXPR2  -  True if both EXPR1 and EXPR2 are true.
# EXPR1 -o EXPR2  -  True if either EXPR1 or EXPR2 is true.

# File type tests
# -b FILE  -  True if FILE exists and is a block special device.
# -c FILE  -  True if FILE exists and is a character special device.
# -d FILE  -  True if FILE exists and is a directory.
# -f FILE  -  True if FILE exists and is a regular file.
# -L FILE  -  True if FILE exists and is a symbolic link.
# -p FILE  -  True if FILE exists and is a named pipe.
# -S FILE  -  True if FILE exists and is a socket.
# -t FD  -  True if FD is a file descriptor that is associated with a terminal.

# Access permission tests
# -g FILE  -  True if FILE exists and has its set-group-id bit set.
# -k FILE  -  True if FILE has its "sticky" bit set.
# -r FILE  -  True if FILE exists and is readable.
# -u FILE  -  True if FILE exists and has its set-user-id bit set.
# -w FILE  -  True if FILE exists and is writable.
# -x FILE  -  True if FILE exists and is executable.
# -O FILE  -  True if FILE exists and is owned by the current effective user id.
# -G FILE  -  True if FILE exists and is owned by the current effective group id.

# File characteristic tests
# -e FILE  -  True if FILE exists.
# -s FILE  -  True if FILE exists and has a size greater than zero.
# FILE1 -nt FILE2  -  True if FILE1 is newer (according to modification date) than FILE2, or if FILE1 exists and FILE2 does not.
# FILE1 -ot FILE2  -  True if FILE1 is older (according to modification date) than FILE2, or if FILE2 exists and FILE1 does not.
# FILE1 -ef FILE2  -  True if FILE1 and FILE2 have the same device and inode numbers,  i.e., if they are hard links to each other.

# String tests
# -z STRING  -  True if the length of STRING is zero.
# -n STRING
# STRING  -  True if the length of STRING is nonzero.
# STRING1 = STRING2  -  True if the strings are equal.
# STRING1 != STRING2  -  True if the strings are not equal.

# Numeric tests
# ARG1 -eq ARG2
# ARG1 -ne ARG2
# ARG1 -lt ARG2
# ARG1 -le ARG2
# ARG1 -gt ARG2
# ARG1 -ge ARG2
############################################################################################################################################################



############################################################################################################################################################
# Optional Software that is awesome
#
# ftp://ftp.gnu.org/pub/gnu/gawk/gawk-3.1.7.tar.gz
# ftp://alpha.gnu.org/pub/gnu/libidn/libidn-1.9.tar.gz
# ftp://ftp.berlios.de/pub/smake/alpha/smake-1.2a45.tar.gz
# ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.9.tar.gz
# ftp://ftp.gnu.org/gnu/gdb/gdb-7.0.tar.bz2
# ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.1.tar.gz
# ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.64.tar.gz
# ftp://ftp.gnu.org/pub/gnu/automake/automake-1.11.tar.gz
# ftp://ftp.gnu.org/pub/gnu/bash/bash-4.0.tar.gz
# ftp://ftp.gnu.org/pub/gnu/bash/bash-doc-3.2.tar.gz
# ftp://ftp.gnu.org/pub/gnu/bash/bashref.texi.gz
# ftp://ftp.gnu.org/pub/gnu/bash/readline-5.1.tar.gz
# ftp://ftp.gnu.org/pub/gnu/binutils/binutils-2.19.tar.gz
# ftp://ftp.gnu.org/pub/gnu/bison/bison-2.4.tar.gz
# ftp://ftp.gnu.org/pub/gnu/findutils/findutils-4.4.2.tar.gz
# ftp://ftp.gnu.org/pub/gnu/fontutils/fontutils-0.7.tar.gz
# ftp://ftp.gnu.org/pub/gnu/g77/g77-0.5.23.tar.gz
# ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.4.2/gcc-4.4.2.tar.gz
# ftp://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.8.4.tar.bz2
# ftp://ftp.gnu.org/pub/gnu/grep/grep-2.5.4.tar.gz
# ftp://ftp.gnu.org/pub/gnu/groff/groff-1.20.tar.gz
# ftp://ftp.gnu.org/pub/gnu/gzip/gzip-1.3.9.tar.gz
# ftp://ftp.gnu.org/pub/gnu/less/less-418.tar.gz
# ftp://ftp.gnu.org/pub/gnu/m4/m4-1.4.13.tar.gz
# ftp://ftp.gnu.org/pub/gnu/make/make-3.81.tar.gz
# ftp://ftp.gnu.org/pub/gnu/nano/nano-2.1.9.tar.gz
# ftp://ftp.gnu.org/pub/gnu/readline/readline-6.0.tar.gz
# ftp://ftp.gnu.org/pub/gnu/screen/screen-4.0.3.tar.gz
# ftp://ftp.gnu.org/pub/gnu/sed/sed-4.2.1.tar.gz
# ftp://ftp.gnu.org/pub/gnu/tar/cpio-2.8.tar.gz
# ftp://ftp.gnu.org/pub/gnu/tar/tar-1.22.tar.gz
# ftp://ftp.gnu.org/pub/gnu/termcap/termcap-1.3.tar.gz
# ftp://ftp.gnu.org/pub/gnu/termutils/termutils-2.0.tar.gz
# ftp://ftp.gnu.org/pub/gnu/wget/wget-1.12.tar.gz
# ftp://ftp.gnu.org/pub/gnu/which/which-2.20.tar.gz
# ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz
# ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.1.tar.bz2
# ftp://xmlsoft.org/libxml2/libxml2-2.7.6.tar.gz
# ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz
# http://c-ares.haxx.se/c-ares-1.6.0.tar.gz
# http://curl.haxx.se/download/curl-7.19.4.tar.gz
# http://download.oracle.com/berkeley-db/db-4.7.25.tar.gz
# http://downloads.sourceforge.net/libpng/libpng-1.2.40.tar.gz
# http://downloads.sourceforge.net/sourceforge/docutils/docutils-0.5.tar.gz
# http://downloads.sourceforge.net/sourceforge/freetype/freetype-2.3.11.tar.gz
# http://downloads.sourceforge.net/sourceforge/ghostscript/ghostscript-8.70.tar.bz2
# http://downloads.sourceforge.net/sourceforge/mcrypt/mcrypt-2.6.8.tar.gz
# http://downloads.sourceforge.net/sourceforge/mhash/mhash-0.9.9.9.tar.gz
# http://downloads.sourceforge.net/sourceforge/strace/strace-4.5.18.tar.bz2
# http://lynx.isc.org/current/lynx2.8.8dev.1.tar.gz
# http://mirrors.kernel.org/gnu/libiconv/libiconv-1.13.1.tar.gz
# http://oss.itsystementwicklung.de/download/pysqlite/2.5/2.5.5/pysqlite-2.5.5.tar.gz
# http://php.net/distributions/php-5.3.0.tar.gz
# http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c9-py2.6.egg
# http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c9.tar.gz
# http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
# http://www.dillo.org/download/dillo-2.1.1.tar.bz2
# http://www.ijg.org/files/jpegsrc.v7.tar.gz
# http://www.libgd.org/releases/gd-2.0.35.tar.gz
# http://www.lua.org/ftp/lua-5.1.4.tar.gz
# http://www.lzop.org/download/lzop-1.02rc1.tar.gz
# http://www.mavetju.org/download/dnstracer-1.9.tar.gz
# http://www.oberhumer.com/opensource/lzo/download/lzo-2.03.tar.gz
# http://www.oberhumer.com/opensource/lzo/download/minilzo-2.03.tar.gz
# http://www.python.org/ftp/python/2.6.3/Python-2.6.3.tgz
# http://www.python.org/ftp/python/3.1.1/Python-3.1.1.tgz
# http://www.sqlite.org/sqlite-3.6.12.tar.gz
# http://www.zlib.net/zlib-1.2.3.tar.gz
# 
############################################################################################################################################################



# Local Variables:
# mode:shell-script
# sh-shell:bash
# End:
