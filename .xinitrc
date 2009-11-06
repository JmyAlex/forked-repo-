#!/bin/sh
#
# ~/.xinitrc
#
WM="xmonad"
#WM="xfce4"
xrdb -merge .Xresources
xrdb -merge .Xdefaults
errorlog="$HOME/.xsession-errors"
xsetroot -cursor_name left_ptr
urxvtd -q -o -f &
xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &

case $WM in
	xmonad)
	#xfce4)
		nitrogen --restore &
		~/bin/dzmpd.sh &
		trayer --edge bottom --align right --expand true --SetDockType true --SetPartialStrut true --tint 0x000000 --alpha 0 --transparent true --height 20 --width 5 --margin 0 &
		xscreensaver -nosplash &
		numlockx &
		mplayer /mnt/data/Themes/system_sound/Infinity_wav_by_Pulicoti/'Infinity Intro.wav' &
		exec ck-launch-session xmonad;;
		#exec ck-launch-session startxfce4;;
esac
