library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity spi_slave_tb is
end spi_slave_tb;

architecture rtl of spi_slave_tb is
 component spi_slave is
  port (
     -- inputs
     clk_in  : in  std_logic;    
     d_in    : out std_logic;    -- spi_slave serial d_in input
     CS      : in  std_logic;    -- chip select input (active low)
     d_out   : in  std_logic;
     data    : out std_logic_vector(9 downto 0)
   );
  end component spi_slave;
  
  signal clk_in_s     : std_logic           := '0';
  signal d_in_s       : std_logic;
  signal CS_s         : std_logic;
  signal d_out_s      : std_logic;
  signal data_s       : std_logic_vector(9 downto 0);

begin
  spi_slave_INST : spi_slave
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
