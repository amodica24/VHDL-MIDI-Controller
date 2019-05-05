-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     SPI_slave.vhd
-- Description  :     This entity is the SPI slave component
--                    that will interact with the FPGA 
--
-- Inputs       :     clk_in    - Input for the clock
--              :     CS        - Chip select, active low input
--              :     d_out     - FIX
--              :
-- Outputs      :     data      - 10 bit data message being read
--              :     d_in      - Bit output sendin
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity spi_slave is
 generic (
  num_clks_per_1_bit : integer := 15  -- = (10Mhz/31250)
  );
  
  port ( 
   clk_in  : in  std_logic;
   d_in    : out std_logic;                   
   CS      : in  std_logic;                     
   d_out   : in  std_logic;
   data    : out std_logic_vector(9 downto 0)
  );
end spi_slave;

architecture RTL of spi_slave is
 --signal d_start : std_logic_vector(3 downto 0) := "1101";
 signal temp        : std_logic_vector(9 downto 0);
 signal clk_count   : integer range 0 to num_clks_per_1_bit := 0;
    --signal index       : integer range 0 to 7 := 0; 
 begin
  process (clk_in, CS)
   begin
   -- 16 clock cycles is length of entire proces
    if (CS = '0') then
     if (clk_count = 0 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      d_in <= '1';
 
     elsif (clk_count = 1 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      d_in <= '1';
     
     elsif (clk_count = 2 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      d_in <= '0';
  
     elsif (clk_count = 3 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      d_in <= '1';
  
     elsif (clk_count = 4 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      d_in <= '0';  

     elsif (clk_count = 5 and falling_edge(clk_in)) then
      clk_count   <= clk_count + 1;
       -- ignore null bit 
     
     elsif (clk_count > 5 and clk_count < 16 and rising_edge(clk_in)) then
      clk_count   <= clk_count + 1;
      temp <= temp(8 downto 0) & d_out; 
     end if;
    data <= temp;
   end if; 


--if (CS = '0' and falling_edge(clk_in)) then
--  
-- if (clk_count = 0 and falling_edge(clk_in)) then
--  clk_count   <= clk_count + 1;
--  d_in <= '1';
--  
--  elsif (clk_count = 1 and falling_edge(clk_in)) then
--   clk_count   <= clk_count + 1;
--   d_in <= '1';
--   
--  elsif (clk_count = 2 and falling_edge(clk_in)) then
--   clk_count   <= clk_count + 1;
--   d_in <= '0';
--   
--  elsif (clk_count = 3 and falling_edge(clk_in)) then
--   clk_count   <= clk_count + 1;
--   d_in <= '1';
--   
--   elsif (clk_count = 4 and falling_edge(clk_in)) then
--    clk_count   <= clk_count + 1;
--    d_in <= '0';  
--
--    elsif (clk_count = 5 and falling_edge(clk_in)) then
--     clk_count   <= clk_count + 1;
--        -- ignore null bit 
--        
--    elsif (clk_count > 5 and clk_count < 16 and rising_edge(clk_in)) then
--     clk_count   <= clk_count + 1;
--     temp <= temp(8 downto 0) & d_out; 
--  end if;
  
  --data <= temp;
--end if;
--  

end process;
end RTL;
