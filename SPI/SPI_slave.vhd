-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     SPI_slave.vhd
-- Description  :     This entity is the SPI slave component
--                    that will interact with the FPGA 
--
-- Inputs       :     clk_in       - Input for the clock
--              :     chip_select  - Reset for the clock
--              :     MOSI_pin     - Pin to select master out, slave in
-- Outputs      :     MISO_pin     - Pin to select master in, slave out
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
Use work.resources.all;

entity SPI_slave is
	port(
    		-- inputs
		chip_select  : IN STD_LOGIC;
		clk_in       : IN STD_LOGIC; 
   		MOSI_pin     : IN STD_LOGIC; -- master out, slave in
    		-- outputs
		MISO_pin     : OUT STD_LOGIC -- master in, slave out
	);
END SPI_slave;
