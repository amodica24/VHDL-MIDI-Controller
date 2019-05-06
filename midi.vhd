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

library gate_lib;
use gate_lib.resources.all;

entity midi is

  generic (
	 -------- uart_tx -------
	 tx_num_clks_per_1_bit : integer := 320   -- = (10Mhz/31250)
  );

  port (
   -------- uart_tx -------
   -- inputs
   tx_clk_in     : in  std_logic;
   tx_enable     : in  std_logic;
   tx_in         : in  std_logic_vector(7 downto 0);
   --outputs
   tx_busy       : out std_logic;
   tx_8bit       : out std_logic;
   tx_out        : out std_logic;
   tx_done       : out std_logic;
	
   -------- mult16 ---------
   mult_d_in     : in std_logic_vector(15 downto 0); 
   mult_sel      : in std_logic_vector(3 downto 0);
   mult_d_out    : out std_logic;
   -------- clkDivide --------
   clk_100MHz    : in std_logic;
   clk_rst       : in std_logic; 
   clk_1MHz      : out std_logic;
	
   -------- spi_master --------
   -- inputs
   spi_clk_in    : in  std_logic;                
   spi_CS        : in  std_logic;                     
   spi_d_out     : in  std_logic;
   -- outputs
   spi_d_in      : out std_logic;   
   spi_data      : out std_logic_vector(9 downto 0)
  );
  
end midi;

architecture rtl of midi is

  -- signal and_out_s : std_logic;
  -- signal or_out_s  : std_logic;
  
  begin

    uart_tx_1 : entity gate_lib.uart_tx(RTL)
    generic map (
      num_clks_per_1_bit => tx_num_clks_per_1_bit
    )
    port map (
	  -- inputs
      clk_in    => tx_clk_in,
	  tx_enable => tx_enable,
	  tx_in     => tx_in,
	  -- outputs
	  tx_busy   => tx_busy,
	  tx_8bit   => tx_8bit,
	  tx_out    => tx_out,
	  tx_done   => tx_done
    );

    mult16_1 : entity gate_lib.mult16(RTL)
    port map(
      d_in      => mult_d_in,
	  sel       => mult_sel,
	  d_out     => mult_d_out
    );

    clkDivide_1 : entity gate_lib.clkDivide(RTL)
    port map(
      clk_100MHz => clk_100MHz,
	  clk_rst    => clk_rst,
	  clk_1MHz   => clk_1MHz
    );
	
	spiMaster_1 : entity gate_lib.spiMaster(RTL)
    port map(
      -- inputs
	  clk_in   => clk_1MHz,
	  CS       => spi_CS,
	  d_out    => spi_d_out,
	  -- outputs
	  d_in     => spi_d_in,
	  data     => spi_data
    );

end rtl;
