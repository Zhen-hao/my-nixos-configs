xrandr --output HDMI-0 --auto --scale 1.5x1.5 --pos

EXT_TOP=DP-4
INT=DP-2
EXT_RIGHT=HDMI-0

ext_top_w=`xrandr | sed 's/^'"${EXT_TOP}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_top_h=`xrandr | sed 's/^'"${EXT_TOP}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
ext_right_w_off=`echo $(($ext_top_w * 3 / 2 )) | sed 's/^-//'`

#xrandr --output "${EXT_RIGHT}" --auto --scale 1.5x1.5 --pos ${ext_right_w_off}x0
#2880x1620
xrandr --output "${EXT_RIGHT}" --auto --panning 1620x2880+2880+0 --scale 1.5x1.5 --right-of "${EXT_TOP}" --rotate right
