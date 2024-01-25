all: \
	checkerboard-1024x1024.png \
	pillars-1024x1024.png \
	pillars-1024x1024.jpg \
	pillars-1024x512.png \
	pillars-1024x512.jpg \
	pillars-768x768.png \
	pillars-768x768.jpg \
	pillars-2048x2048.png \
	pillars-2048x2048.jpg \
	pillars-1024x1024.png.truncated \
	pillars-1024x1024.jpg.truncated \
	nonsense.bin

# Download the test image from the James Webb Telescope website.
pillars.png:
	curl 'https://stsci-opo.org/STScI-01GGF8H15VZ09MET9HFBRQX4S3.png' > $@

# A complex `ImageMagick` command to procedurally generate when a
# black-and-white checkerboard image. The output file is a grayscale
# PNG (i.e. a PNG with a single channel, with a bit depth of 1).
#
# I copied this command from https://unix.stackexchange.com/a/721855.
#
# A helpful breakdown of the various command line options from
# OpenAI's GPT-4:
#
# ---- BEGIN_QUOTE ----
# This ImageMagick command creates a specific pattern (a two-color
# checkerboard) and then writes it to `mask.png`. Here's a brief
# explanation of each option:
#
# - `-size 64x64` : This option defines the size of the image or image portion to be created, in this case, a width and height of 64 pixels.
# - `xc:black` and `xc:white` : These commands generate a plain black or white canvas of the size specified previously.
# - `+append` : This option appends two images side-by-side. It takes the two preceding images (`xc:black` and `xc:white`) and concatenates them horizontally.
# - `\( +clone -flop \)` : `+clone` creates a copy of the existing image(s) in memory, and `-flop` mirrors the cloned image(s) about the y-axis. These actions are enclosed in parentheses to apply operations on a set of images as a group.
# - `-append` : This will append the preceding images vertically (opposite of `+append`).
# - `-write MPR:x` : This writes the image to a named memory program register indexed by 'x'. This is used for temporary storage of the image(s).
# - `-delete 0` : This deletes the first image from the current image sequence.
# - `-size 512x512` : It sets a new image size.
# - `tile:MPR:x` : This fetches the image stored in the MPR with the identifier 'x', and tiles this image across the canvas of the size defined by `-size 512x512`.
# - `mask.png` : This is the output file, where the resulting image will be saved.
#
# So, in summary, it creates a 64x64 px black and white block,
# duplicates and mirrors it horizontally, appends the original and
# mirrored together vertically, deletes the original image sequences,
# scales the result to a 512x512 px image, and finally, writes the
# output to `mask.png`.
# ---- END_QUOTE ----
checkerboard-grayscale-%.png:
	convert -size 64x64 xc:black xc:white +append \( +clone -flop \) -append \
		-write MPR:x -delete 0 -size $* tile:MPR:x $@

# A checkboard PNG where the color is solid white and the black squares
# are made by setting the alpha value to zero.
checkerboard-alpha-%.png: checkerboard-grayscale-%.png
	convert -size $* xc:white $< -alpha off -compose copy_opacity -composite $@

# Extract a square area from the image.
pillars-7680x7680.png: pillars.png
	convert $< -crop 7680x7680+391+1426 $@

# Note: This rule handles generating images with non-square target
# sizes by:
#
# (1) resizing to the target width using `-resize` in combination with
# the "fill area flag" (`^`), then
# (2) cropping to the target height using `-gravity top -extent`.
#
# For further are explanation and examples, see the documentation for
# ImageMagick's "Fill Area Flag" (`^`) at:
# https://legacy.imagemagick.org/Usage/resize/#fill
pillars-%.png: pillars-7680x7680.png
	convert $< -filter Catrom -resize $*^ -gravity North -extent $* $@

# Convert from PNG -> JPG.
%.jpg: %.png
	convert $< $@

# Create a truncated PNG/JPG file, to test if Rabbit gracefully
# handles truncated files.
%.truncated: %
	head -c 312320 $< > $@

# Create a binary file containing random bytes, to test if Rabbit
# correctly identifies/handles files that are not in PNG/JPG format.
nonsense.bin:
	head -c 131072 /dev/urandom > $@
