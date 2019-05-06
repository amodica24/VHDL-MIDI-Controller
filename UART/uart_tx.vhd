  -----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-------------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the transmitter to send data 
--                   from the UART port of the FPGA to the computer
--
-- Inputs      :     clk_in        - Input clock
--             :     tx_enable     - Enable bit for beginning data transfer
--             :     tx_in         - The 8 bit message being transmitted
--             :
-- Outputs     :     tx_busy       - Bit that detects the status of transmission
--             :     tx_out        - The 8 bit message received from the transmitter
--             :     tx_done       - bit detects when done transmitting
-------------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-18 - Initial Version
-- 1.1 - 2019-04-21 - Idle state needed reworking, the testbench
--                    did not reflect when the message was not transmitted
-- 1.3 - 2019-04-24 - Fixed the number of clocks per bit to reflect the frequency
--                    of the FPGA
-- 1.3 - 2019-04-24 - Added more inputs to demonstrate the different stages of 
--                    the transmitting message
-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
 generic (
  num_clks_per_1_bit : integer := 320   -- = (100Mhz/31250)
 );
 port (
 -- inputs
 clk_in      : in  std_logic;
 tx_enable   : in  std_logic;
 tx_in     : in  std_logic_vector(7 downto 0);
 --outputs
 tx_busy     : out std_logic;
 tx_8bit     : out std_logic;
 tx_out    : out std_logic;
 tx_done     : out std_logic
);
end uart_tx;

architecture RTL of uart_tx is

 type tx_states is (
  idle_s,        -- idle state, does not do anything
  start_bit_s,   -- sends a 0 as the MSB bit
  data_s,        -- transfers 8 bits
  stop_bit_s     -- sends a 1 as the last bit
 );

 -- initialization
 signal state_s     : tx_states;
 signal clk_count   : integer range 0 to num_clks_per_1_bit-1 := 0;
 signal index       : integer range 0 to 7 := 0; 

begin

 p_uart_tx : process (clk_in)
 begin
  if rising_edge(clk_in) then
     
   case state_s is

    -- Case 1: Idle state
    -- 'busy' bit = '0'
    -- 'idle' bit = '0'
    when idle_s =>
      tx_busy   <= '0';    -- not transmitting
      tx_8bit  <= '0';
      tx_out  <= '1';    --
      tx_done   <= '0'; 
    
      if (tx_enable = '1') then
      -- go to next state when enable is 1
        state_s <= start_bit_s;
      else
      -- else, stay in idle
        state_s <= idle_s;
      end if;
    
    -- Case 2: Start Bit state
    -- Find the start bit of the transmitted message
    when start_bit_s =>
      tx_out <= '0';      -- first bit is 0 when message is transmitting
      tx_busy  <= '1';    -- indicate the process is being busy
      
		-- check the end of the clock count to go to next state
      if (clk_count < num_clks_per_1_bit - 1) then
        clk_count   <= clk_count + 1;
        state_s     <= start_bit_s;
      
      else -- go to next state (Case 3)
        clk_count <= 0;
        state_s <= data_s;
      end if;

    -- Case 3: Data Bits state
    -- this stage transmits the message by shifting it right
    when data_s =>             
      tx_out <= tx_in(index);   -- transmits one bit at a time
      tx_8bit <= '1';
      
      -- go to next state once end of clock cycle 
      if (clk_count < num_clks_per_1_bit - 1) then
        clk_count   <= clk_count + 1;
        state_s   <= data_s;
      else
        clk_count   <= 0;
         
        -- Check if we have sent out all bits
        if (index < 7) then
          index <= index + 1;
          state_s   <= data_s;
        else
        -- after sending out all bits, go to next state
          index <= 0;
          state_s   <= stop_bit_s;
        end if;
      end if;

    -- Case 4: Stop bit state
    -- stop bit = 1
    -- Stops the transmission of bits
    when stop_bit_s =>
      tx_out <= '1';           -- '1', stop bit
      tx_8bit <= '0';

      -- check the end of the clk count to go to next state
      if clk_count < num_clks_per_1_bit-1 then
        clk_count <= clk_count + 1;
        state_s   <= stop_bit_s;
      
      -- once reached, go back to idle state
      else
        tx_busy <= '0';        -- shows it is not transmitting
        tx_done <= '1';        -- output shows it is done transmitting
        clk_count <= 0;        -- reset the clock count to redo the process
        state_s   <= idle_s;   -- return to idle state
      end if;

    when others =>
      state_s <= idle_s;

  end case;
end if;
end process p_uart_tx;

end RTL;
