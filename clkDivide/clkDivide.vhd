-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     clkDivide.vhd
-- Description  :     This entity is a clock divider to be implemented
--             	      with the analog-to-digital converter and multiplexer
--
-- Inputs       :     clk_in  - Input for the clock
--              :     clk_rst - Reset for the clock
-- Outputs      :     new_clk - Output clock
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
Use work.resources.all;

entity clkDivide is
	port(
		clk_in  : IN STD_LOGIC;
		clk_rst : IN STD_LOGIC; 
		new_clk : OUT STD_LOGIC
	);
end clkDivide;

architecture behav of clkDivide is
	signal temp_clk : std_logic; 
begin
	p1: process (clk_in, clk_rst)
	variable clk_count  : integer; -- keeps track of clock cycles
	begin
		if (clk_rst = '1') then -- hold the clock during reset
			clk_count := 0;
			temp_clk  <= '0';
		elsif (clk_in'event AND clk_in = '1') then
	       -- elsif(risingedge(clk_in)) then
			clk_count := clk_count + 1;
			if (clk_count = 1) then
				clk_count := 0;
				temp <= NOT temp;
			end if;
		end if;	
	end process;
	new_clk <= temp_clk;
end behav;
