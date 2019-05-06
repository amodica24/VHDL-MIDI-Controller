-----------------------------------------------------------------------------
-- Project      :     VHDL MIDI Controller
-- Author       :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File         :     midi.vhd
-- Description  :     
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity midi_tb is
end midi_tb;
 
architecture test of midi_tb is 

   -------- uart_tx -------
   -- inputs
   signal tx_clk_in     :   std_logic;
   signal tx_enable     :   std_logic;
   signal tx_in         :   std_logic_vector(7 downto 0);
   --outputs
   signal tx_busy       :   std_logic;
   signal tx_8bit       :   std_logic;
   signal tx_out        :   std_logic;
   signal tx_done       :   std_logic;
	
   -------- mult16 ---------
   signal mult_d_in     :   std_logic_vector(15 downto 0); 
   signal mult_sel      :   std_logic_vector(3 downto 0);
   signal mult_d_out    :   std_logic;
   -------- clkDivide --------
   signal clk_100MHz    :   std_logic;
   signal clk_rst       :   std_logic; 
   signal clk_1MHz      :   std_logic;
	
   -------- spi_master --------
   -- inputs
   signal spi_clk_in    :   std_logic;                
   signal spi_CS        :   std_logic;                     
   signal spi_d_out     :   std_logic;
   -- outputs
   signal spi_d_in      :   std_logic;   
   signal spi_data      :   std_logic_vector(9 downto 0)

begin
 
  -- instantiate the unit under test (uut)
  midi_uut : entity work.midi(rtl)
  port map (
   -------- uart_tx -------
   -- inputs
   clk_in    => tx_clk_in,
   tx_enable => tx_enable,
   tx_in     => tx_in,
   -- outputs
   tx_busy   => tx_busy,
   tx_8bit   => tx_8bit,
   tx_out    => tx_out,
   tx_done   => tx_done,
   
   -------- mult16 ---------
   -- inputs
   d_in      => mult_d_in,
   sel       => mult_sel,
   -- output
   d_out     => mult_d_out,
   
   -------- clkDivide --------
   -- inputs
   clk_100MHz => clk_100MHz,
   clk_rst    => clk_rst,
   -- output
   clk_1MHz   => clk_1MHz,

   -------- spi_master --------
   -- inputs
   clk_in   => clk_1MHz,
   CS       => spi_CS,
   d_out    => spi_d_out,
   -- outputs
   d_in     => spi_d_in,
   data     => spi_data   
  );

  -- stimulus process
  stim_proc : process
  begin
  
  end process;

end test;
