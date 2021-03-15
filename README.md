![screenshot](https://github.com/fastrgv/RufasSwap/blob/master/icon_512x512%402x.png)

# RufasSwap
RufasSwap is a simple permuted picture puzzle for kids that runs on Mac OS-X and GNU Linux

Click on the large 7z file under releases for all source & binaries, or try this link:

https://github.com/fastrgv/RufasSwap/releases/download/v2.6.0/sw21feb21.7z





# RufaSwap


**ver 2.6.0 -- 21feb21**

* Upgraded to OpenAL sound.


## See full revision history at end of file


----------------------------------
## Rufaswap
Rufaswap is a simple permuted picture puzzle app where the challenge is to restore the picture elements to their proper place.  Two elements are selected with cursor clicks to initiate a swap.  User controls the level of difficulty by choosing the number of slices, and whether even or irregular.

Works on Windows, Macs running OS-X(>=10.13) and PCs running GNU/Linux.

Simply unzip and run.  If the binary executables do not run on your system then follow the build instructions below.

----------------------------------

 * Uses GLFW3 & OpenAL sound;
 * Works on OS-X Retina displays;
 * all runtime files are in ./data/
 * several png picture files are provided in ./pix/
 * you can use your own png files;

----------------------------------------------
## Run Requirements:
 * graphics card/driver that supports OpenGL version 3.3 or later;


------------------------------------------------------
## Setup & Running:


Mac users see "osx-setup.txt".
Windows users see "windows-setup.txt".

Unzip the archive.  On Windows, 7z [www.7-zip.org] works well for this. The proper command to extract the archive and maintain the directory structure is "7z x filename".


Open a commandline terminal, and cd to the install directory.

At the command line, type the executable name to start the game.

-------------------------------------------------------------------
Windows users type "rufaswap.bat".

-------------------------------------------------------------------
Linux users may type rufaswap_gnu, or double click the icon of rufaswap_gnu in file manager.

The distributed linux executable requires glibc v2.14 or newer.  That means if your distribution is older, it might not run, and you will need to recompile.

-------------------------------------------------------------------
Mac users note that this game may be initiated in two ways, also.  First, by opening a terminal, navigating to the install_directory, and typing rufaswap_osx on the command line.  Second by navigating to the installation directory in Finder and clicking the "rufaswap.app" icon named "RufasSwap".
 

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
Uses the Ada programming language and fully modern OpenGL methods, with textures, shaders and uniforms.  Achieves version 3.3 core profile contexts.  Compiles and runs on MSwin32, GNU/Linux and Mac OS-X systems.

Focusing on portability and open source freedom, this project relies on a thin GLFW3 binding, a thin OpenGL binding, a homebrew OpanAL binding, & a PNG reader by Stephen Sanguine.



----------------------------------------------
## Build Requirement:
 * a recent gnat compiler;
 * Xcode g++ compiler, if using OS-X>=10.13(sep2017)


----------------------------------------------
## Build instructions for Rufaswap

Three [pre-compiled] binary executables are provided, 
one for windows (rufaswap.exe), 
one for gnu/linux (rufaswap_gnu) and one for OS-X (rufaswap_osx).  The OSX executable is intended to have minimal runtime requirements.  The linux binary, rufaswap_gnu, is intended to run on 64-bit linux in the presence of the directory "libs", which contains some dynamically loaded libraries that can be, but need not be present on a target system: freetype & GLFW3.  The windows executable requires the included DLLs to be collocated with it to run;  so it was put into its own separate directory to avoid clutter.

Build scripts are now described;  and due to a recent script change, a Windows or linux build machine need not have a C++ compiler installed.  Only GNAT is required.

-------------------------------------------------------
msWin64 => wcmpa.bat

-------------------------------------------------------
MacOSX => ocmpss.sh:

build script for generating a portable executable that will run on most OS-X platforms whether or not they have non-standard libraries such as GLFW, SFML installed.  I used this to build the executable that I deliver, named rufaswap_osx.

------------------------------------------------------
GNU/Linux => lcmpd2.sh:

utilizes some relocatable libraries that I deliver in this bundle under ./libs/.  I use this to build the gnu/linux executable that I deliver, named rufaswap_gnu, which should run in the presence of ./libs, whether or not your system has the libraries in it.

If the delivered linux binary does not run...

* Manually install GNAT GPL from libre.adacore.com/download/.
* Rerun the compile script lcmpd.sh, or lcmpss.sh.


### Link Problems during linux build:

On a linux build machine, you might have fixable link errors, depending on its configuration.  If you are missing "libz", you can simply copy "libz.so" from the AdaCore ~/lib/ directory into /usr/local/lib/.  If "libGL" cannot be found, this literally means "libGL.so" was absent.  But you might have "libGL.so.1" present.  In this case, simply create a softlink by changing to the libGL directory, then type the line:

sudo ln -s libGL.so.1 libGL.so  (and enter the admin password)

whence the linker should now be able to find what it wants.  But if there is more than one file libGL.so present on your system, make sure you use the best one;  i.e. the one that uses accelerated graphics.





------------------------------------------------------
## rufaswap is covered by the GNU GPL v3 license:

 Copyright (C) 2021  <fastrgv@gmail.com>

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


## Revision History:

**ver 2.5.5 -- 27oct20**
* Elliminated SFML-audio entirely.
* Greatly simplified build process.


**ver 2.5.4 -- 20sep20**
* Updated all glfw libs to v3.3.2.
* Added "rufaswap.bat" for Windows users.

**ver 2.5.3 -- 18apr20**
* Shaders corrected so that OpenGL v3.3 is now sufficient to run this app., thus allowing older hardware.



**ver 2.5.2 -- 09mar20**
* Fixed annoying window sizing mismatch (since the conversion to glfw);

**ver 2.5.1 -- 18jan20**
* Significant enhancement to linux portability;

**ver 2.5.0 -- 03jan20**
* Converted to GLFW3;
* Improved compile scripts;
* Added FreeType lettering (stex.adb);

