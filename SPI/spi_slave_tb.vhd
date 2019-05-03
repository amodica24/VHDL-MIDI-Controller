library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity spi_slave_tb is
end spi_slave_tb;
 
architecture rtl of spi_slave_tb is
  component spi_slave is
    port (
      -- inputs
	 clk_in  : in  STD_LOGIC;    -- spi_slave input clock
     d_in    : in  STD_LOGIC;    -- spi_slave serial d_in input
     CS      : in  STD_LOGIC;    -- chip select input (active low)
     d_out   : out STD_LOGIC_VECTOR (7 downto 0)
    );
  end component spi_slave;

  signal clk_in_s     : std_logic                    := '0';
  signal d_in_s       : std_logic;
  signal CS_s         : std_logic;
  signal d_out_s      : std_logic_vector(7 downto 0);
   
begin
 
  -- Instantiate UART transmitter
  spi_slave_INST : spi_slave
    port map (
      clk_in  => clk_in_s,
      d_in    => d_in_s,
      CS      => CS_s,
      d_out   => d_out_s
      );
     clk_in_s <= not clk_in_s after 50 ns;
  process is
  begin
 
    -- Tell the UART to send a command
	wait for 50 ns;
    CS_s <= '0';
	wait until rising_edge(clk_in_s);
	d_in_s <= '1';
	wait until rising_edge(clk_in_s);
	d_in_s <= '0';
	wait until rising_edge(clk_in_s);
	d_in_s <= '1';
	wait until rising_edge(clk_in_s);
	d_in_s <= '0';
	wait until rising_edge(clk_in_s);
	d_in_s <= '0';
	wait until rising_edge(clk_in_s);
	d_in_s <= '1';
	wait until rising_edge(clk_in_s);
	d_in_s <= '0';
	wait until rising_edge(clk_in_s);
	d_in_s <= '1';
	wait until rising_edge(clk_in_s);
	wait for 50 ns;
	CS_s <= '1'; 
	wait;
     
  end process;
   
end rtl;
