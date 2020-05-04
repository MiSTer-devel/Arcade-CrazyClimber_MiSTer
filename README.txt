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
--   5,6 : Add coin
--   1,2 : Start Player 1, Player 2
--
-- Joystick/Gamepad support.
-- 
-- 
---------------------------------------------------------------------------------

                                *** Attention ***

ROMs are not included. In order to use this arcade, you need to provide the
correct ROMs.

To simplify the process .mra files are provided in the releases folder, that
specifies the required ROMs with checksums. The ROMs .zip filename refers to the
corresponding file of the M.A.M.E. project.

Please refer to https://github.com/MiSTer-devel/Main_MiSTer/wiki/Arcade-Roms for
information on how to setup and use the environment.

Quickreference for folders and file placement:

/_Arcade/<game name>.mra
/_Arcade/cores/<game rbf>.rbf
/_Arcade/mame/<mame rom>.zip
/_Arcade/hbmame/<hbmame rom>.zip
