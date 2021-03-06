-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     clkDivide.vhd
-- Description  :     This entity is a clock divider to be implemented
--                    with the analog-to-digital converter and multiplexer
--
-- Inputs       :     clk_100MHz  - Input for the clock
--              :     clk_rst     - Reset for the clock
--
-- Outputs      :     clk_1MHz    - Output clock
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
  -- inputs
  clk_100MHz   : in std_logic;
  clk_rst      : in std_logic;
  -- output
  clk_1MHz     : out std_logic
  );
 end component;

 ---------------------------------
 -- signals
 ---------------------------------

 -- inputs
 signal clk_100MHz_s   : std_logic;
 signal clk_rst_s      : std_logic;
 -- output
 signal clk_1MHz_s     :  std_logic;

 -- clock period
 constant clk_period : time := 10 ns;

 begin
    -- Instantiate the Unit Under Test (UUT)
  uut: clkDivide PORT MAP (
   clk_100MHz => clk_100MHz_s,
   clk_rst => clk_rst_s,
   clk_1MHz => clk_1MHz_s
  );

 -- clock process
 clk_process : process
  begin
   clk_100MHz_s <= '0';
   wait for clk_period/2;
   clk_100MHz_s <= '1';
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
