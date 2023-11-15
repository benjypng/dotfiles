function convertgif
	ffmpeg -i $argv -pix_fmt rgb24 -r 20 -f gif -  | gifsicle --optimize=3 --delay=3 > my.gif
end
