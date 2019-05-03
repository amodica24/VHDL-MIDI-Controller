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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity spi_slave is
  port ( 
    clk_in  : in  STD_LOGIC;    -- spi_slave input clock
    
    d_in    : in  STD_LOGIC;    -- spi_slave serial d_in input
    CS      : in  STD_LOGIC;    -- chip select input (active low)
    d_out   : out STD_LOGIC_VECTOR (11 downto 0)
  );
end spi_slave;

architecture RTL of spi_slave is
    signal d_start : STD_LOGIC_VECTOR (3 downto 0) := "1101";
    signal data : STD_LOGIC_VECTOR (11 downto 0);
begin
  
process (clk_in, CS)
begin
  if (rising_edge(clk_in)) then  -- rising edge of clk_in
    if (CS = '0') then           -- spi_slave CS must be selected
      -- shift serial d_in into data on each rising edge
      -- of clk_in, MSB first
      data <= d_start(3 downto 0) & data(6 downto 0) & d_in;
    end if;
  end if;
    
  if (rising_edge(CS)) then
   -- update d_outs with new d_in on rising edge of CS
   d_out <= data;
  end if;

end process;
end RTL;
