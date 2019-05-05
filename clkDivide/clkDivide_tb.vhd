-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     clkDivide_tb.vhd
-- Description  :     This entity is a clock divider to be implemented
--                    with the analog-to-digital converter and multiplexer
--
-- Inputs       :     clk_in_s  - Input for the clock
--              :     clk_rst_s - Reset for the clock
-- Outputs      :     new_clk_s - Output clock
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

Library IEEE;
USE IEEE.std_logic_1164.ALL;

entity clkDivide_tb is
end clkDivide_tb;

architecture rtl of clkDivide_tb is

component clkDivide
port(
	clk_in   : in std_logic;
	clk_rst  : in std_logic;
	new_clk  : out std_logic
	);
end component;

-- inputs
signal clk_in_s   : std_logic;
signal clk_rst_s  : std_logic;
-- outputs
signal new_clk_s :  std_logic;

-- clock period
constant clk_period : time := 10 ns; -- insert the clk period being used

begin
    -- Instantiate the Unit Under Test (UUT)
  uut: clkDivide PORT MAP (
    clk_in => clk_in_s,
    clk_rst => clk_rst_s,
    new_clk => new_clk_s
   );

-- clock process
clk_process : process
   begin
      clk_in_s <= '0';
      wait for clk_period/2;
      clk_in_s <= '1';
      wait for clk_period/2;
   end process;

-- stimulus process
-- test each case for the reset
stim_proc: process
   begin
   clk_rst_s <= '1'; 
    wait for clk_period; 
    clk_rst_s <= '0'; 
    wait; 
   end process;

end;
