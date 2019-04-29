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
-- 1.0 - 2019-04-29 - Initial Version
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
  d_in_s <= "0000000000000000";
  sel_s <= "0000";
  wait for 40 ns;
  d_in_s <= "0000000000000010";
  sel_s <= "0001"; 
  wait for 20 ns;
  d_in_s <= "0000000000000000";
  sel_s <= "0001"; 
  wait for 40 ns;
  d_in_s <= "1000000000000010";
  sel_s <= "1111";  
  wait for 30 ns; 
  wait;
  end process;
END;
