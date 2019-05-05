  -------------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
---------------------------------------------------------------------------------------
-- File        :     uart_tx_tb.vhd
-- Description :     This entity is the transmitter to send data 
--                   from the UART port of the FPGA to the computer
--
-- Inputs      :     clk_in        - Input clock
--             :     tx_enable     - Enable bit for beginning data transfer
--             :     tx_in         - The 8 bit message being transmitted
--             :
-- Outputs     :     tx_busy       - Bit that detects the status of transmission
--             :     tx_out        - The 8 bit message received from the transmitter 
--             :                     1 bit at a time
--             :     tx_done       - Bit detects when done transmitting
---------------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-18 - Initial Version
-- 1.1 - 2019-04-21 - Idle state needed reworking, the testbench
--                    did not reflect when the message was not transmitted
-- 1.2 - 2019-04-24 - Fixed the number of clocks per bit to reflect the frequency
--                    of the FPGA
-- 1.3 - 2019-04-25 - Added more testbenches and asserts for simulation
-- 1.3 - 2019-04-29 - Included an output to show when the 8 bits are being transmitted
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_tx_tb is
end uart_tx_tb;

architecture rtl of uart_tx_tb is

component uart_tx is
  generic (
    num_clks_per_1_bit : integer := 320   -- Needs to be set correctly
    );
  port (
    -- inputs
    clk_in     : in  std_logic;
    tx_enable  : in  std_logic;
    tx_in      : in  std_logic_vector(7 downto 0);
    -- outputs;
    tx_busy    : out std_logic;
    tx_8bit    : out std_logic;
    tx_out     : out std_logic;
    tx_done    : out std_logic
    );
end component uart_tx;
 
-- Test Bench uses a 10 MHz Clock
-- Want to interface to 115200 baud UART
-- 10000000 / 115200 = 87 Clocks Per Bit.

constant num_clks_per_1_bit_s : integer := 320;
------------------------------------------
-- signals
------------------------------------------

-- inputs
signal clk_in_s     : std_logic                    := '0';
signal tx_enable_s  : std_logic                    := '0';
signal tx_in_s      : std_logic_vector(7 downto 0) := (others => '0');
-- outputs
signal tx_busy_s    : std_logic;
signal tx_8bit_s    : std_logic;
signal tx_out_s     : std_logic;
signal tx_done_s    : std_logic;
 
begin

-- Instantiate UART transmitter
UART_TX_INST : uart_tx
  generic map (
    num_clks_per_1_bit => num_clks_per_1_bit_s
    )
  port map (
    clk_in      => clk_in_s,
    tx_enable   => tx_enable_s,
    tx_in       => tx_in_s,
    tx_busy     => tx_busy_s,
    tx_8bit     => tx_8bit_s,
    tx_out      => tx_out_s,
    tx_done     => tx_done_s
    );

clk_in_s <= not clk_in_s after 50 ns;
 
process is
begin
  wait until rising_edge(clk_in_s);
  tx_in_s     <= "11110000";
  tx_enable_s <= '0';
  wait for 10 us;
  wait until rising_edge(clk_in_s);
  tx_enable_s <= '1';
  wait for 320 us;
  tx_enable_s <= '0';
  wait for 320 us;
  tx_enable_s <= '1';
  wait for 320 us;
  tx_in_s     <= "11110011";
  wait;
   
end process;
 
end rtl;
