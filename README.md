![screenshot](https://github.com/fastrgv/RufasSwap/blob/master/icon_512x512%402x.png)

![screenshot](https://github.com/fastrgv/RufasSwap/blob/master/lara.gif)


# RufasSwap
RufasSwap is a simple permuted picture puzzle for kids that runs on Mac OS-X and GNU Linux

Click on the large 7z file under releases for all source & binaries, or try this link:

https://github.com/fastrgv/RufasSwap/releases/download/v2.6.8/sw7oct23.7z

Type "7z x filename" to extract the archive.

## GitHub Note: Please ignore the "Source code" zip & tar.gz files. (They are auto-generated by GitHub). Click on the large 7z file under releases to download all source & binaries (Windows,Mac & Linux). Then, type "7z x filename" to extract the archive. 








# RufaSwap


## What's new:


**ver 2.6.8 -- 7oct2023**

* Revived OSX support.


**ver 2.6.7 -- 15dec2022**

* Added Windows 64-bit build using stand-alone GNU Ada compiler.
* Discontiued OSX development.
* New linux build now runs on very old linux distros.


### See full revision history at end of file


----------------------------------
## Rufaswap
Rufaswap is a simple permuted picture puzzle app where the challenge is to restore the picture elements to their proper place.  Two elements are selected with cursor clicks to initiate a swap.  User controls the level of difficulty by choosing the number of slices, and whether even or irregular.

Works on desktops & laptops running Windows, OSX, or Linux.

-----------------------------------------------------------
Featuring

 * no installation
 * no dependencies
 * simply unzip in your Downloads directory, and run;
 * or unzip onto a USB flash drive [w/same file format] and run.
 * Works on HiDpi displays;
 * several png picture files are provided in ./pix/
 * or, you can use your own png files;
-----------------------------------------------------------

## Run Requirements:
 * graphics card/driver that supports OpenGL version 3.3 or later;


------------------------------------------------------
## Setup & Running:


Mac users see "osx-setup.txt".
Windows users see "windows-setup.txt".

Unzip the archive.  

* On Linux & Windows, 7z [www.7-zip.org] works well for this. The proper command to extract the archive and maintain the directory structure is "7z x filename".

* On OSX, Keka will handle 7z files.  The command-line for Keka works thusly:
	* /Applications/Keka.app/Contents/MacOS/Keka --cli 7z x (filename.7z)

After the archive is unzipped...

Open a commandline terminal, and cd to the install directory.

At the command line, type the executable name to start the game.

-------------------------------------------------------------------
Mac users type:

	rufaswap_osx

-------------------------------------------------------------------
Windows users type:

rufaswap.bat (Windows 64-bit)

-------------------------------------------------------------------
Linux users may type:
	rufaswap_gnu, 

or double click the icon of rufaswap in file manager.

You can also run the windows EXEs under wine thusly:

	* wine cmd < rufaswap.bat, or
	* wine binw32/rufaswap.exe

Note: Windows users should NOT try running the linux executables under WSL [Windows Subsystem for Linux]; that mode is not supported. Simply use the windows version.

**If an older Linux system complains that /dev/dsp/ cannot be opened, prepend the command with "padsp",EG:  "padsp (ExeName)".**



-------------------------------------------------------------------

	The install_directory should contain subdirectories named "data", "libs", "pix".


To swap two blocks, click the cursor on them.  The first selection is highlighted, whence you may either click it again to deselect, or click another to swap.

Press (n) or (p) to go to the Next or Previous picture;

Press (m) or (f) to make puzzle harder or easier [More or Fewer slices];
Press (u) to toggle uneven partitions;

Press (esc) to quit.

Note that you can use your own pictures if they are PNG files,  although several photos taken by the author are included.


Please send questions, comments or corrections to fastrgv@gmail.com

----------------------------------------------

## what is special about this project?
Uses the Ada programming language and fully modern OpenGL methods, with textures, shaders and uniforms.  Achieves version 3.3 core profile contexts.  Compiles and runs on MSwin32, GNU/Linux systems.

Focusing on portability and open source freedom, this project relies on a thin GLFW3 binding, a thin OpenGL binding, a homebrew OpanAL binding, & a PNG reader by Stephen Sanguine that uses Dmitriy Anisimkov's Zlib for Ada.



----------------------------------------------
## Build Requirement:
 * a recent Ada compiler;

See:
	* https://github.com/alire-project/GNAT-FSF-builds/releases



----------------------------------------------
## Build instructions for Rufaswap

Build scripts for GNU Ada [with its own g++] are provided. 

-------------------------------------------------------
mac/osx => ocmp.sh

-------------------------------------------------------
msWin64 => setpath64.bat; wcmp64.bat

-------------------------------------------------------
GNU/Linux => lcmp.sh:







------------------------------------------------------
## rufaswap is covered by the GNU GPL v3 license:

 Copyright (C) 2023  <fastrgv@gmail.com>

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
It is my intention to use media with copyrights or licenses that are compatible with GPLv3. Please notify me if you believe there is an incompatibility, and it will be removed ASAP, eg a CC-by-NC license is NOT GPL compatible.



### SoundFiles
...are from freesound.org and are covered by the Creative Commons CC0 license documented in the accompanying file creativeCommons.txt.

### ImageFiles (*.png)
For text-textures were created using gimp and are covered by the GNU GPL v3 license.  Likewise for other photo images, all of which were taken by the author.

----------------------------------------------
## Download Sites for all my games:
https://github.com/fastrgv?tab=repositories
https://www.indiedb.com/members/fastrgv/games
https://fastrgv.itch.io
https://sourceforge.net/u/fastrgv/profile/
https://gamejolt.com/@fastrgv/games



## Revision History:

**ver 2.6.6 -- 16sep2022**
* Now using GNU Ada rather than defunct AdaCore compiler.
* Using Mingw32 GNU Ada on Windows.

**ver 2.6.5 -- 16apr2022**
* Reverted linux libraries to exclusively shared format for portability.

**ver 2.6.4 -- 20jan2022**
* Updated linux libs to use static libfreetype.a & libpng16.a
* Updated Windows builds to freetype v2.11.1 DLLs (w32,w64).
* Updated libglfw.



