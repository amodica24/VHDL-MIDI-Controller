-----------------------------------------------------------------------------
-- Project          :     VHDL MIDI Controller
-- Author           :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File             :     mult16.vhd
-- Description      :     This entity is a 16-1 multiplexer
--
-- Inputs           :     d_in
--                  :     sel     

-- Outputs          :     
--                  :     d_out
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-20 - Initial Version
-- 1.1 - 2019-04-27 - Changed from 16 inputs to 1 input with 16 bit logic vector
-- 1.2 - 2019-04-28 - Inserted assert statements
-- 1.3 - 2019-04-29 - Implemented more test cases
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mult16_tb IS
END mult16_tb;
ARCHITECTURE rtl OF mult16_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT mult16
    PORT(
	-- inputs
    d_in   : in std_logic_vector(15 downto 0);
    sel    : in std_logic_vector(3 downto 0);
    -- outputs
    d_out : out std_logic
    );
    END COMPONENT;
    --Inputs
    signal d_in_s : std_logic_vector(15 downto 0);
    signal sel_s : std_logic_vector(3 downto 0);
    --Outputs
    signal d_out_s : std_logic;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
  uut: mult16 PORT MAP (
    d_in => d_in_s,
    sel => sel_s,
    d_out => d_out_s
   );
-- Stimulus process
stim_proc: process
 begin
  d_in_s <= "1100 0011 1101 0110";
  sel_s <= "0000";
  
  wait for 5ns;
  assert (d_out_s = '0') report "Output is a 0" severity failure;
  wait for 35ns;
  
  sel_s <= "0001"; 
  wait for 5ns;
  assert (d_out_s = '1') report "Output is a 1" severity failure;
  wait for 50ns;
  
  sel_s <= "0010"; 
  wait for 5ns;
  assert (d_out_s = '1') report "Output is a 1" severity failure;
  wait for 35ns;
  
  sel_s <= "0011";
  wait for 5ns;
  assert (d_out_s = '0') report "Output is a 0" severity failure;
  wait for 35 ns;
	  
  sel_s <= "0100";
  wait for 5ns;
  assert (d_out_s = '1') report "Output is a 1" severity failure;
  wait for 35 ns;
   
  end process;
END;
