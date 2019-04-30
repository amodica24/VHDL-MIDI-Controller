-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx_tb.vhd
-- Description :     This entity is the testbench that is used to test uart_tx
--
-- Inputs      :     clk_in       - input clock
--             :     tx_enable    - transmit enable bit
--             :     tx_data      - the 8 bits being transmitted
-- Outputs     :     tx_busy      - bit for detecting bits are being transmitted
--             :     tx_start     - start bit
--             :     tx_done      - bit detects when done transmitting
-----------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity uart_tx_tb is
end uart_tx_tb;
 
architecture behave of uart_tx_tb is
 
  component uart_tx is
    generic (
      clk_per_bit : integer := 115   -- Needs to be set correctly
      );
    port (
      -- inputs
      clk_in     : in  std_logic;
      tx_enable  : in  std_logic;
      tx_data    : in  std_logic_vector(7 downto 0);
      -- outputs
      tx_busy    : out std_logic;
      tx_start   : out std_logic;
      tx_done    : out std_logic
      );
  end component uart_tx;
   
  -- Test Bench uses a 10 MHz Clock
  -- Want to interface to 115200 baud UART
  -- 10000000 / 115200 = 87 Clocks Per Bit.
  constant c_CLKS_PER_BIT : integer := 87;
 
  constant c_BIT_PERIOD : time := 8680 ns;
   
  signal clk_in_s     : std_logic                    := '0';
  signal tx_enable_s     : std_logic                    := '0';
  signal tx_data   : std_logic_vector(7 downto 0) := (others => '0');
  signal tx_start_s : std_logic;
  signal tx_done_s   : std_logic;
   
begin
 
  -- Instantiate UART transmitter
  UART_TX_INST : uart_tx
    generic map (
      clk_per_bit => c_CLKS_PER_BIT
      )
    port map (
      clk_in       => clk_in_s,
      tx_enable     => tx_enable_s,
      tx_data   => tx_data,
      tx_busy => open,
      tx_start => tx_start_s,
      tx_done   => tx_done_s
      );

  clk_in_s <= not clk_in_s after 50 ns;
   
  process is
  begin
 
    -- Tell the UART to send a command.
    wait until rising_edge(clk_in_s);
    wait until rising_edge(clk_in_s);
    tx_enable_s   <= '1';
    tx_data <= X"FF";
    wait until rising_edge(clk_in_s);
    tx_enable_s   <= '0';
    wait until tx_done_s = '1';
    wait;
     
  end process;
   
end behave;
