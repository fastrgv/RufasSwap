![screenshot](https://github.com/fastrgv/RufasSwap/blob/master/icon_512x512%402x.png)

# RufasSwap
RufasSwap is a simple permuted picture puzzle for kids that runs on Mac OS-X and GNU Linux

Click on the large tar.gz file under releases for all source & binaries, or try this link:

https://github.com/fastrgv/RufasSwap/releases/download/v2.3.5/swap4jan17.tar.gz


# RufaSwap  v2.3.5
## What's new (newest @ top):

**4jan17 v2.3.5**

* Updated to use new SFML libs.
* Corrected a duplicate window glitch.
* Refined compiler scripts.

**30dec16 v2.3.4**

* Improved linux build system to be compatible with more linux distros.
* Improved OpenGL coding to run on embedded graphics hardware.


**10dec16 v2.3.3**

* Added interesting new (u)-key option to toggle uneven random partitions.


**02jul16 v2.3.2**

* Updated to use ada-intrinsic pseudo-random numbers, including a time dependent randomization so each run is different.
* Improved snd4ada.cpp, whoosh sound.


**12apr16 v2.3.1**

* Important library update for Gnu/Linux users on 27% of distros that do not provide FLAC, ogg, vorbis libraries.  Missing softlinks caused run failure.  That is now fixed.



**19feb16 v2.3**

* Added Mac binary bundle that acts much more like a typical Mac App.  This app is delivered in the installation directory, but could be moved elsewhere, such as your personal Applications directory [and initiated with a click].  Note that there are some soft [symbolic] links in the bundle that are resolved automatically when copied with the command "cp -r rufaswap.app destination-directory".
* Generalized utex package.
* Improved help screen.


**29nov15 v2.2**

 * Improved PNG loader procedure that handles either RGBA or RGB image files for textures.  This means most of your own PNG images should work.  Thusly, it now works with all of the pictures delivered.


**20nov15 v2.1**

 * initial rewrite in the Ada language of its c++ predecessor.
 * this version does not yet handle RGB images, as did the c++ predecessor.



----------------------------------
Rufaswap is a simple permuted picture puzzle where the challenge is to restore the picture elements to their proper order.  Two elements are selected with cursor clicks to initiate a swap.  User controls the level of difficulty.

It uses a thin SDL2 binding from Dan Vazquez, a thin OpenGL binding from "Lumen", a PNG reader for Ada by Stephen Sanguine, and SFML-Audio (because of its elegant audio interface).


Works on Macs running OS-X and PCs running GNU/Linux.

----------------------------------

 * Uses SDL2;
 * Works on OS-X Retina displays;
 * Uses SFML for sound;
 * all runtime files are in ./data/
 * several *.png files are provided in ./pix/
 * you can use your own *.png files;

----------------------------------------------
## Run Requirements:
 * graphics card/driver that supports OpenGL version 3.3 or later;

## Build Requirement:
 * a recent gnat compiler;
 * Xcode g++ compiler, if using OS-X


----------------------------------------------
## Build instructions for Rufaswap

Two [pre-compiled] binary executables are provided, one for gnu/linux and one for OS-X.  The static OSX executable is intended to have minimal runtime requirements:   rufaswap_osx.  The other binary, rufaswap_gnu, is intended to run on 64-bit linux in the presence of the directory "libs", which contains some dynamically loaded libraries that can be, but need not be present on a target system:  
SDL2, SFML, FLAC, ogg, vorbis, & openal.

Build scripts are now described;  and due to a recent script change, a linux build machine need not have a C++ compiler installed.  Only GNAT is required.

-------------------------------------------------------
MacOSX => ocmp.sh:

build script for generating a portable executable that will run on most OS-X platforms whether or not they have non-standard libraries such as SDL2, SFML installed.  I used this to build the executable that I deliver, named rufaswap_osx.

------------------------------------------------------
GNU/Linux => scmp.sh:

utilizes the relocatable libraries that I deliver in this bundle under ./libs/.  I use this to build the gnu/linux executable that I deliver, named rufaswap_gnu, which should run in the presence of ./libs, whether or not your system has the libraries in it.

The current build is compiled on OpenSUSE v13.2, and uses GLIBC 2.14 [dating from june 2011].  This generally means that if your linux distro uses glibc v2.14 or newer, then the prebuilt binary should probably run on your system (and be rebuildable).

If the delivered linux binary does not run...

* Manually install GNAT GPL from libre.adacore.com/download/.
* Rerun the compile script scmp.sh, or lcmp.sh.


### Link Problems during linux build:

On a linux build machine, you might have minor link errors, depending on its configuration.  If you are missing "libz", you can simply copy "libz.so" from /usr/gnat/lib/gps/ into /usr/local/lib/.  If "libGL" cannot be found, this literally means "libGL.so" was absent.  But you might have "libGL.so.1" present.  In this case, simply create a softlink by changing to the libGL directory, then type the line:

sudo ln -s libGL.so.1 libGL.so  (and enter the admin password)

whence the linker should now be able to find what it wants.  But if there is more than one file libGL.so present on your system, make sure you use the best one;  i.e. the one that uses accelerated graphics.




------------------------------------------------------
## Running:

Unzip the archive and you will see a new directory appear with a name like bundle_date, that you should rename to something like install_directory.  

Users should then cd to install_directory, then, at the command line, type the executable name to start the game.

Linux users may also double click the icon of rufaswap_gnu in file manager.

Mac users note that this game may be initiated in two ways, also.  First, by opening a terminal, navigating to the install_directory, and typing rufaswap_osx on the command line.  Second by navigating to the installation directory in Finder and clicking the "rufaswap.app" icon named "RufasSwap".
 

The install_directory should contain subdirectories named "data", "libs", "pix".


So, at the command line type:
	rufaswap_gnu ( or rufaswap_osx )

To swap two blocks, click the cursor on them.  The first selection is highlighted, whence you may either click it again to deselect, or click another to swap.

Press (n) or (p) to go to the Next or Previous picture;

Press (m) or (f) to make puzzle harder or easier [More or Fewer slices];
Press (u) to toggle uneven partitions;

Press (esc) to quit.


Please send questions, comments or corrections to fastrgv@gmail.com

------------------------------------------------------
## rufaswap is covered by the GNU GPL v3 license:

 Copyright (C) 2015  <fastrgv@gmail.com>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may read the full text of the GNU General Public License
 at <http://www.gnu.org/licenses/>.


## Media Files for rufaswap:

### General Note
The particular choices of sound files delivered are not essential to the function of the game and are easily replaced.  This software is primarily intended as a tutorial example of modern OpenGL methods.  The only requirements are that sounds be in WAV format.

### SoundFiles
...are from freesound.org and are covered by the Creative Commons Attribution noncommercial license documented in the accompanying file creativeCommons.txt.

### ImageFiles (*.png)
For text-textures were created using gimp and are covered by the GNU GPL v3 license.  Likewise for other photo images, all of which were taken by the author.

----------------------------------------------
## Best Download Site for all my games:
https://github.com/fastrgv?tab=repositories

