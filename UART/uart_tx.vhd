-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the transmitter to send data 
--                   from the UART port of the FPGA to the computer
--
-- Inputs      :     clk_in        - input clock
--             :     tx_enable     - transmit enable bit
--             :     tx_data       - the 8 bits being transmitted
-- Outputs     :     tx_busy       - bit for detecting bits are being transmitted
--             :     tx_start      - start bit
--             :     tx_done       - bit detects when done transmitting
-----------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity uart_tx is
  generic (
    clk_per_bit : integer := 320     -- = (10Mhz/31250)
    );
  port (
    -- inputs
    clk_in      : in  std_logic;
    tx_enable   : in  std_logic;
    tx_data     : in  std_logic_vector(7 downto 0);
    --outputs
    tx_busy     : out std_logic;
    tx_start    : out std_logic;
    tx_done     : out std_logic
    );
end uart_tx;
 
architecture RTL of uart_tx is
 
  type t_SM_Main is (idle_state, find_start_bit, get_data_bits_tx,
                     find_stop_bit);
  signal r_SM_Main : t_SM_Main := idle_state;
 
  signal clk_count   : integer range 0 to clk_per_bit-1 := 0;
  signal index       : integer range 0 to 7 := 0;  
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
   
begin
   
  p_uart_tx : process (clk_in)
  begin
    if rising_edge(clk_in) then
         
      case r_SM_Main is
 
        -- Case 1: Idle state
        -- 'busy' bit input = '0' AND serial bit input = '1'
        when idle_state =>
          tx_busy   <= '0';    -- '0', idle
          tx_start  <= '1';    -- '1', idle
          r_TX_Done <= '0';
          clk_count <= 0;
          index     <= 0;
        
          -- go to next state when enable is 1
          if (tx_enable = '1') then
            r_TX_Data <= tx_data;
            r_SM_Main <= find_start_bit;
          else
          -- else, stay in idle
            r_SM_Main <= idle_state;
          end if;
        
        -- Case 2: Start Bit state
        -- 'busy' bit input = '1' and serial bit input = '0'
        when find_start_bit =>
          tx_busy  <= '1';         -- '1', 'busy' bit
          tx_start <= '0';         -- '0' = start bit
          
          -- check the end of the clk count to go to next state
          if (clk_count < clk_per_bit-1) then
            clk_count   <= clk_count + 1;
            r_SM_Main   <= find_start_bit;
          
            -- go to next state (Case 3)
          else
            clk_count <= 0;
            r_SM_Main <= get_data_bits_tx;
          end if;
 
        -- Case 3: Data Bits state
        when get_data_bits_tx =>
          tx_start <= r_TX_Data(index);   -- data bits
           
          if clk_count < clk_per_bit-1 then
            clk_count   <= clk_count + 1;
            r_SM_Main   <= get_data_bits_tx;
          else
            clk_count <= 0;
             
            -- Check if we have sent out all bits
            if index < 7 then
              index <= index + 1;
              r_SM_Main   <= get_data_bits_tx;
            else
              index <= 0;
              r_SM_Main   <= find_stop_bit;
            end if;
          end if;
 
        -- Case 4: Stop bit state
        -- stop bit = 1
        -- Stops the transmission of bits
        when find_stop_bit =>
          tx_start <= '1';           -- '1', stop bit
 
          -- check the end of the clk count to go to next state
          if clk_count < clk_per_bit-1 then
            clk_count <= clk_count + 1;
            r_SM_Main   <= find_stop_bit;
          
          -- once reached, go back to idle state
          else
            tx_busy <= '0';
            r_TX_Done   <= '1';         -- '1', done transmitting all bits
            clk_count <= 0;           -- '0', reset clock count
            r_SM_Main   <= idle_state;
          end if;

        when others =>
          r_SM_Main <= idle_state;
 
      end case;
    end if;
  end process p_uart_tx;
 
  tx_done <= r_TX_Done;
   
end RTL;
