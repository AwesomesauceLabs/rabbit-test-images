# Rabbit Test Images

## Acknowledgments

All test images are derived from the "Pillars of Creation" image taken by the James Webb telescope, which is in the public domain. I did not include the full-size image in this repo (due to size constraints), but you can obtain it from the following web page:

<https://webbtelescope.org/contents/media/images/2022/052/01GF423GBQSK6ANC89NTFJW8VM>

## Files

| File                                                               | Valid PNG/JPG? | Note                    |
|------                                                              |----------------|------                   |
| [pillars-1024x1024.png](pillars-1024x1024.png)                     | Yes            | Test normal 1K PNG file |
| [pillars-1024x1024.jpg](pillars-1024x1024.jpg)                     | Yes            | Test normal 1K JPG file |
| [pillars-2048x2048.png](pillars-2048x2048.png)                     | Yes            | Test normal 2K PNG file |
| [pillars-2048x2048.jpg](pillars-2048x2048.jpg)                     | Yes            | Test normal 2K JPG file |
| [pillars-1024x1024-truncated.png](pillars-1024x1024-truncated.png) | No             | Test truncated PNG file |
| [pillars-1024x1024-truncated.jpg](pillars-1024x1024-truncated.jpg) | No             | Test truncated JPG file |
| [nonsense.bin](nonsense.bin)                                       | No             | Test non-PNG/JPG input  |

## Shell commands to generate the files

Download the source image with `curl`, then use ImageMagick's `convert` and other
Unix command line tools to generate the derived image files of various sizes:

```
curl 'https://stsci-opo.org/STScI-01GGF8H15VZ09MET9HFBRQX4S3.png' > pillars.png

convert pillars.png -crop 7680x7680+391+1426 pillars-7680x7680.png

convert pillars-7680x7680.png -filter Catrom -resize 2048x2048 pillars-2048x2048.png
convert pillars-7680x7680.png -filter Catrom -resize 1024x1024 pillars-1024x1024.png

convert pillars-2048x2048.png pillars-2048x2048.jpg
convert pillars-1024x1024.png pillars-1024x1024.jpg

head -c 312320 pillars-1024x1024.jpg > pillars-1024x1024-truncated.jpg
head -c 1048576 pillars-1024x1024.png > pillars-1024x1024-truncated.png

head -c 131072 /dev/urandom > nonsense.bin
```
