-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     spi_master.vhd
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
-- 1.0 - 2019-04-20 - Initial Version

-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity spi_master is
  port ( 
   -- inputs
   clk_in  : in  std_logic;                
   CS      : in  std_logic;                     
   d_out   : in  std_logic;
   -- outputs
   d_in    : out std_logic;   
   data    : out std_logic_vector(9 downto 0)
  );
end spi_master;

architecture RTL of spi_master is
 signal d_start     : std_logic_vector(4 downto 0) := "01011";
 signal temp        : std_logic_vector(9 downto 0);
 signal clk_count   : integer range 0 to 15 := 0;
 signal index       : integer := 0;
 
 begin
  process (clk_in, CS)
   begin
   -- 16 clock cycles is length of entire proces
    if falling_edge(clk_in) then
      clk_count <= clk_count +1;      -- count how many clock cycles on falling edge
    end if;
    
    if (falling_edge(CS)) then        -- reset the clk_count for every falling edge
     clk_count <= 0;                  
    end if;
    
    if clk_count < 5 then
     index <= clk_count;              -- increment index until fifth clock cycle
    end if;                           
    
    if (CS = '0') then
     if (falling_edge(clk_in)) then   -- for every clock cycle on falling edge,
      d_in <= d_start(index);         -- access the 4 bits from d_start
     elsif (clk_count > 5 and clk_count < 16 and rising_edge(clk_in)) then
      temp <= temp(8 downto 0) & d_out; 
     end if;
    data <= temp;
   end if;

 end process;
end RTL;
