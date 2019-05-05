-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     clkDivide.vhd
-- Description  :     This entity is a clock divider to be implemented
--                    with the analog-to-digital converter and multiplexer
--
-- Inputs       :     clk_100MHz  - Input 100 MHz clock
--              :     clk_rst     - Reset for the clock
-- Outputs      :     clk_1MHz    - Output 1 MHz clock
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
--Use work.resources.all;

entity clkDivide is
  port(
    clk_100MHz  : in std_logic;
    clk_rst     : in std_logic;
    clk_1MHz    : out std_logic
	);
end clkDivide;

architecture rtl of clkDivide is
  signal temp_clk  : std_logic; 
  signal clk_count : integer := 0;
  signal div_value : integer := 100;
begin
  p1: process (clk_100MHz, clk_rst)
    begin
      -- 100 MHz / 100 = 1 MHz 
      if (clk_rst = '1') then -- hold the clock during reset
       clk_count <= 0;
       temp_clk  <= '0';
      elsif (rising_edge(clk_100MHz)) then
       clk_count <= clk_count + 1;
	      if (clk_count = div_value) then
	       clk_count <= 0;
	       temp_clk <= NOT temp_clk;
        end if;
       end if;
  end process;
 clk_1MHz <= temp_clk;
end rtl;
