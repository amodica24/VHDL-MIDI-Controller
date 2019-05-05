-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     SPI_master.vhd
-- Description  :     This entity is the SPI master component
--                    that will interact with the FPGA 
--
-- Inputs       :     clk_in    - Input for the clock
--              :     CS        - Chip select, active low input
--              :     d_out     - FIX
--              :
-- Outputs      :     data      - 10 bit data message being read
--              :     d_in      - 
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity spi_master_tb is
end spi_master_tb;

architecture rtl of spi_master_tb is
 component spi_master is
  port (
     -- inputs
     clk_in  : in  std_logic;    
     d_in    : out std_logic;    
     CS      : in  std_logic;    
     d_out   : in  std_logic;
     data    : out STD_LOGIC_VECTOR (9 downto 0)
   );
  end component spi_master;
  
  signal clk_in_s     : std_logic           := '0';
  signal d_in_s       : std_logic;
  signal CS_s         : std_logic;
  signal d_out_s      : std_logic;
  signal data_s       : std_logic_vector(9 downto 0);

begin
  spi_master_INST : spi_master
    port map (
      clk_in  => clk_in_s,
      d_in    => d_in_s,
      CS      => CS_s,
      d_out   => d_out_s,
      data    => data_s
      );
     
	 clk_in_s <= not clk_in_s after 50 ns;
  
process is
  begin 
  -- d_in_s  <= '0'; 
        d_out_s <= '0'; 
        CS_s <= '1';
        wait for 75 ns;
        CS_s <= '0';
        wait for 375 ns;
        wait until falling_edge(clk_in_s);
        d_out_s <= '1';              -- null bit 
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		
		-- transmit the second message
		wait for 100 ns;
		wait for 50 ns;
		d_out_s <= '0'; 
		CS_s <= '1';
		wait for 75 ns;
		CS_s <= '0';
		wait for 375 ns;
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';              -- null bit 
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '0';
		wait until falling_edge(clk_in_s);
		d_out_s <= '1';
		
		wait;
  end process;
   
end rtl;
