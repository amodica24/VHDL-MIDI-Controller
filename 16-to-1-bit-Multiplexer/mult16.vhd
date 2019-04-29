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

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

ENTITY mult16 is
  PORT(
    a   : out std_logic_vector(15 downto 0); 
    sel : in std_logic_vector(3 downto 0);
    q   : out std_logic
  );
  END mult16;
  
  ARCHITECTURE rtl OF mult16 is
    BEGIN
      mult_process : process(a,sel)
    BEGIN 
      case sel is
       when "0000" => q <= a(0);
       when "0001" => q <= a(1);
       when "0010" => q <= a(2);
       when "0011" => q <= a(3);
       when "0100" => q <= a(4);
       when "0101" => q <= a(5);
       when "0110" => q <= a(6);
       when "0111" => q <= a(7);
       when "1000" => q <= a(8);
       when "1001" => q <= a(9);
       when "1010" => q <= a(10);
       when "1011" => q <= a(11);
       when "1100" => q <= a(12);
       when "1101" => q <= a(13);
       when "1110" => q <= a(14);
       when "1111" => q <= a(15);
       when others => q <= 'X';
end case;
  end process mult_process;
  end rtl;
