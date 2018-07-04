#!/bin/sh
# extend non-HiDPI external display on DP* above HiDPI internal display eDP*
# see also https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319

EXT=DP-4
INT=DP-2

ext_w=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
int_w=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
off_w=`echo $(( ($int_w-$ext_w * 3/2))) | sed 's/^-//'`

new_int_h=`echo $(($ext_h * 3/2 )) | sed 's/^-//'`

xrandr --output "${INT}" --auto --pos ${off_w}x${new_int_h} --scale 1x1  --output "${EXT}" --auto --scale 1.5x1.5 --pos 0x0
