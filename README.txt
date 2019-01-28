---------------------------------------------------------------------------------
-- 
-- Arcade: Crazy Climber port to MiSTer by Sorgelig
-- 7 June 2018
-- 
---------------------------------------------------------------------------------
-- Crazy climber FPGA by Dar - (darfpga@aol.fr)
-- http://darfpga.blogspot.fr
---------------------------------------------------------------------------------
-- gen_ram.vhd
-------------------------------- 
-- Copyright 2005-2008 by Peter Wendrich (pwsoft@syntiac.com)
-- http://www.syntiac.com/fpga64.html
---------------------------------------------------------------------------------
-- T80/T80se - Version : 0247
-----------------------------
-- Z80 compatible microprocessor core
-- Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
---------------------------------------------------------------------------------
-- 
-- 
-- Keyboard inputs :
--
--   F1          : Add coin + Start 1 player
--   F2          : Add coin + Start 2 players
--   W,A,S,D     : Left hand movements
--   UP,DOWN,LEFT,RIGHT arrows : Right hand movements
--
-- Joystick/Gamepad support.
-- 
-- 
---------------------------------------------------------------------------------

                                *** Attention ***

ROM is not included. In order to use this arcade, you need to provide a correct ROM file.

Find this zip file somewhere. You need to find the file exactly as required.
Do not rename other zip files even if they also represent the same game - they are not compatible!
The name of zip is taken from M.A.M.E. project, so you can get more info about
hashes and contained files there.

To generate the ROM using Windows:
1) Copy the zip into "releases" directory
2) Execute bat file - it will show the name of zip file containing required files.
3) Put required zip into the same directory and execute the bat again.
4) If everything will go without errors or warnings, then you will get the a.*.rom file.
5) Copy generated a.*.rom into root of SD card along with the Arcade-*.rbf file

To generate the ROM using Linux/MacOS:
1) Copy the zip into "releases" directory
2) Execute build_rom.sh
3) Copy generated a.*.rom into root of SD card along with the Arcade-*.rbf file

To generate the ROM using MiSTer:
1) scp "releases" directory along with the zip file onto MiSTer:/media/fat/
2) Using OSD execute build_rom.sh
3) Copy generated a.*.rom into root of SD card along with the Arcade-*.rbf file
