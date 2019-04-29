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

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

ENTITY mult16 is
  PORT(
    d_in   : in std_logic_vector(15 downto 0); 
    sel    : in std_logic_vector(3 downto 0);
    d_out  : out std_logic
  );
  END mult16;
  
  ARCHITECTURE rtl OF mult16 is
    BEGIN
      mult_process : process(d_in,sel)
    BEGIN 
      case sel is
       when "0000" => d_out <= d_in(0);
       when "0001" => d_out <= d_in(1);
       when "0010" => d_out <= d_in(2);
       when "0011" => d_out <= d_in(3);
       when "0100" => d_out <= d_in(4);
       when "0101" => d_out <= d_in(5);
       when "0110" => d_out <= d_in(6);
       when "0111" => d_out <= d_in(7);
       when "1000" => d_out <= d_in(8);
       when "1001" => d_out <= d_in(9);
       when "1010" => d_out <= d_in(10);
       when "1011" => d_out <= d_in(11);
       when "1100" => d_out <= d_in(12);
       when "1101" => d_out <= d_in(13);
       when "1110" => d_out <= d_in(14);
       when "1111" => d_out <= d_in(15);
       when others => d_out <= 'X';
end case;
  end process mult_process;
  end rtl;
