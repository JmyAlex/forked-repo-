#!/bin/sh
#
# ~/.xinitrc
#
WM="xmonad"
#WM="openbox"
xrdb -merge .Xresources
errorlog="$HOME/.xsession-errors"
xsetroot -cursor_name left_ptr
urxvtd -q -o -f &
#xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
case $WM in
	xmonad)
	#openbox)
		nitrogen --restore &
		#conky &
		#~/.openboxconkyrc
		#~/bin/dzconky.sh &
		~/bin/dzmpd.sh &
		#~/.run-xmonad.sh
		trayer --edge bottom --align right --expand true --SetDockType true --SetPartialStrut true --tint 0x303030 --alpha 0 --transparent true --height 20 --width 5 --margin 0 &
		xscreensaver -nosplash &
		numlockx &
		play /mnt/data/Themes/system_sound/La2/login_dion.wav &
		exec ck-launch-session xmonad;;
		#exec ck-launch-session openbox;;
esac
