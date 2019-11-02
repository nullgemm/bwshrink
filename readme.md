# bwshrink
bwshrink packs black and white rgb data.

Just give it a raw rgb file (like Gimp's `.data` format)
to pack the bits vertically, each byte holding 8 pixels:
```
bwshrink <in.data/rgb> <out.bin/bw> <width> <height>
```

## Usage
Build
```
make
```

Pack the test file (`res/font_big.data`) as `res/font_big.bin`
```
make run
```

For a quick and dirty visual check you can use the following command
(of course the image will appear sideways and only 8 lines at a time)
```
xxd -b -c 1 res/font_big.bin | less
```

## License
The test file (`res/font_big.data`) is also licensed under WTFPL
(it is a black and white ascii font for ssd1306-controlled oled screens)
