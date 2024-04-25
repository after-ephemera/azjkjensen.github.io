+++
title = 'lily58 upgrade notes'
date = 2024-04-25T06:14:34-07:00
+++

I have been seeing some intermittent keyboard restarts lately from my lily58 so I decided yesterday to update the firmware (circuitpython) and the kmk keyboard software running on it. These are my notes to help remember next time how I navigated it.

__To get the keyboard into boot mode, tap the reset button twice. It should come up as a different drive (not the LULUL/LULUR ones) called something like `RPI-RP2`.__

The generic boardsource instructions are [here](https://www.boardsource.xyz/docs/guides-flashing_a_uf2) but I wasn't sure exactly which board mine corresponded to since it's a lily58 but they call it Lulu in so many places.

Once I dragged and dropped the `.uf2` file onto the drive, it rebooted. For some reason I had to do this for both sides, which doesn't appear to be documented anywhere. So plug in the USB-C, flash one board, plug it into the other side, flash that side.

After this a bunch of incompatible APIs totally borked things. I had to pull out another keyboard to debug (never have less than two keyboards!). I ended up getting pretty familiar with the entire code stack I'm running, which is actually really nice. It's less intimidating now.

My first issue was actually seeing what the errors were. The keyboard oleds only show a tiny portion of the Python output when they crash, and only for seconds. I found out that I can connect to the serial line with the board connected via 
```zsh
screen /dev/tty.usbmodem83201 19200 
```
I don't know if that baud rate is correct but it seems to work fine. In order to discover the tty to use, I ran 
```zsh
ls /dev/tty.* 
```
with the board connected, disconnected it, and ran it again.

Since I updated circuitpython, I also had to update the adafruit libraries that kmk uses so everything could be compatible and play nicely again. I got these from their [circuitpython bundle](https://github.com/adafruit/Adafruit_CircuitPython_Bundle/tree/20240423) and went through the tedious process of trying to run the code, looking at which lib was missing, and adding that lib. That way I only got what I needed. 

I checked these files into [my repo](https://github.com/after-ephemera/keeb_cfg/tree/main) so that I would just have exactly what I needed in the future and have a reference point when I want to upgrade again.

There was an incompatible oled API that was actually a bug in the KMK extension for my Blok board. I updated the `show(x)` calls to `.root_group = x` and that fixed it. I [opened a PR](https://github.com/KMKfw/kmk_firmware/pull/965) to make this work for everyone.

After all that work I am still seeing restarts every once in a while, though they do seem less often. Now that I know how to view the serial output I think I'll be able to debug it better.
