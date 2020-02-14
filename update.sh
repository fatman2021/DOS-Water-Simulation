export VIDEO_FORMAT=NTSC
rm -fvr ./dvd/*.*
# mencoder mf://frames/*.bmp -mf w=720:h=480:fps=60:type=bmp -ovc copy -audiofile output.wav -ovc copy -oac copy -o output.mp4
ffmpeg -framerate 60 -i ./frames/frame%04d.bmp -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p output.mp4
# mencoder -ovc copy -audiofile output.wav -oac copy input.mp4 -o output.mp4
mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd:tsaf -vf scale=352:240,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=18:vstrict=0:acodec=ac3:abitrate=192:aspect=16/9 -ofps 30000/1001 -o output.mpg output.mp4
dvdauthor -o dvd -x dvd.xml
mkisofs -dvd-video -udf -o output.iso dvd/
cdrecord -v dev=/dev/sr0 blank=all
cdrecord -v dev=/dev/sr0 output.iso
