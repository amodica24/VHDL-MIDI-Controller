-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     SPI_slave.vhd
-- Description  :     This entity is the SPI slave component
--                    that will interact with the FPGA 
--
-- Inputs       :     clk_in       - Input for the clock
--              :     slave_select
--              :     d_in         - data input
--              :     MOSI_pin     - Pin to select master out, slave in
-- Outputs      :     MISO_pin     - Pin to select master in, slave out
--              :     d_out        - data output, where we are reading our data
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
		slave_select : IN STD_LOGIC;
		clk_in       : IN STD_LOGIC; 
   		MOSI_pin     : IN STD_LOGIC; -- master out, slave in
		d_in         : IN STD_LOGIC_VECTOR(7 downto 0); 
    		-- outputs
		MISO_pin     : OUT STD_LOGIC; -- master in, slave out
		d_out        : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END SPI_slave;
  
  BEGIN
    
    if (slave_select = '0')
      -- slave select must remain low until transmission is complete
      
      -- if high, SPI slave forced to IDLE state
