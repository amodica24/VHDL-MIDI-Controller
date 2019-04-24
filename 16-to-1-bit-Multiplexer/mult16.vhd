-----------------------------------------------------------------------------
-- Project	    :     VHDL MIDI Controller
-- Author  	    :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File		    :     mult16.vhd
-- Description      :     This entity is a 16-1 multiplexer
-- 		
-- Inputs           :     a
--                  :     b
--                  :     c
--                  :     d
--                  :     e1
--                  :     f
--                  :     g
--                  :     h
--                  :     i
--                  :     j
--                  :     k
--                  :     l
--                  :     m
--                  :     n
--                  :     o
--                  :     sel     

-- Outputs	    :     new_clk_s - Output clock
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
Use work.resources.all;
ENTITY mult16 is
	GENERIC( 
		trise : delay := 10 ns;
		tfall : delay := 8 ns 
	);
	PORT(
		a   : IN STD_LOGIC; 
		b   : IN STD_LOGIC;
		c   : IN STD_LOGIC; 
		d   : IN STD_LOGIC;
		e1  : IN STD_LOGIC; 
		f   : IN STD_LOGIC;
		g   : IN STD_LOGIC; 
		h   : IN STD_LOGIC;
		i   : IN STD_LOGIC; 
		j   : IN STD_LOGIC;
		k   : IN STD_LOGIC; 
		l   : IN STD_LOGIC;
		m   : IN STD_LOGIC; 
		n   : IN STD_LOGIC;
		o   : IN STD_LOGIC; 
		p   : IN STD_LOGIC;

		sel : IN STD_LOGIC;
		
		q   : OUT STD_LOGIC
	);
END mult16;
ARCHITECTURE behav OF mult16 IS
BEGIN
	mult_process : PROCESS (a,b,c,d, sel)
	BEGIN 
		case sel is
			when "0000" => q <= a;
                        when "0001" => q <= b;
                        when "0010" => q <= c;
                        when "0011" => q <= d;
                        when "0100" => q <= e1;
                        when "0101" => q <= f;
                        when "0110" => q <= g;
                        when "0111" => q <= h;
                        when "1000" => q <= i;
                        when "1001" => q <= j;
                        when "1010" => q <= k;
                        when "1011" => q <= l;
                        when "1100" => q <= m;
                        when "1101" => q <= n;
                        when "1110" => q <= o;
                        when "1111" => q <= p;
                end case;
	end process mult_process;
end behav;
