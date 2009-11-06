#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#-----------------------------------------------------------------------
# exec ion
# exec jwm
# exec wmaker
# exec startkde
# exec icewm
# exec blackbox
# exec gnome-session
# exec startfluxbox
# exec startxfce4
# exec xfce4-session
# exec openbox
# exec startlxde
# exec  pekwm
# start XMonad
#-----------------------------------------------------------------------
WM="xmonad"
#WM="xfce4"
#xrdb -merge .Xresources
#xrdb -merge .Xdefaults
errorlog="$HOME/.xsession-errors"
xsetroot -cursor_name left_ptr
urxvtd -q -o -f &
xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &

case $WM in
	xmonad)
	#xfce4)
		nitrogen --restore &
		/home/enko/bottoml.sh &
		#/home/enko/bottomr.sh &
		#/home/enko2/bin/bottoml.sh &
		#/home/enko2/bin/bottomr.sh &
		trayer --edge bottom --align right --expand true --SetDockType true --SetPartialStrut true --tint 0x000000 --alpha 0 --transparent true --height 20 --width 5 --margin 0 &
		xscreensaver -nosplash &
		numlockx &
		exec ck-launch-session xmonad;;
		#exec ck-launch-session startxfce4;;
esac
