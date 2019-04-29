-----------------------------------------------------------------------------
-- Project          :     VHDL MIDI Controller
-- Author           :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File             :     mult16.vhd
-- Description      :     This entity is a 16-1 multiplexer
--
-- Inputs           :     a
--                  :     sel     

-- Outputs          :     
--                  :     q
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
    a   : IN std_logic_vector(15 downto 0);
    sel : in std_logic_vector(3 downto 0);
    
    q : OUT std_logic
    );
    END COMPONENT;
    --Inputs
    signal a_sig : std_logic_vector(15 downto 0);
    signal sel_sig : std_logic_vector(3 downto 0);
    --Outputs
    signal q_sig : std_logic;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
  uut: mult16 PORT MAP (
    a => a_sig,
    sel => sel_sig,
    q => q_sig
   );
-- Stimulus process
stim_proc: process
 begin
  a_sig <= "0000000000000000";
  sel_sig <= "0000";
  wait for 40 ns;
  a_sig <= "0000000000000010";
  sel_sig <= "0001"; 
  wait for 20 ns;
  a_sig <= "0000000000000000";
  sel_sig <= "0001"; 
  wait for 40 ns;
  a_sig <= "1000000000000010";
  sel_sig <= "1111";  
  wait for 30 ns; 
  wait;
  end process;
END;
