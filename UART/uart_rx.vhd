-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the receiver that receives the message 
--                   being transmitted from the UART port of the FPGA
--
-- Inputs      :     clk_in          - clock
--             :     tx_enable    - transmit enable bit
-- Outputs     :     tx_detect        - bit for detecting bits are being transmitted
--             :     rx_start      - start bit
-----------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity uart_rx is
  generic (
    clk_per_bit : integer := 320     -- =(10Mhz/31250)
    );
  port (
    -- inputs
    clk_in       : in  std_logic;
    tx_enable : in  std_logic;
    -- outputs
    tx_detect     : out std_logic;
    rx_start   : out std_logic_vector(7 downto 0)
    );
end uart_rx;
 
 architecture rtl of uart_rx is
 
  type t_SM_Main is (idle_state, get_start_bit, get_bits,
                     get_stop_bit, reset_state);
  signal r_SM_Main : t_SM_Main := idle_state;
 
  signal r_RX_Data_R : std_logic := '0';
  signal r_RX_Data   : std_logic := '0';

  signal clk_count : integer range 0 to clk_per_bit-1 := 0;
  signal index : integer range 0 to 7 := 0;  
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
   
begin
 
  p_clk : process (clk_in)
  begin
    if rising_edge(clk_in) then
      r_RX_Data_R <= tx_enable;
      r_RX_Data   <= r_RX_Data_R;
    end if;
  end process p_clk;
   
  p_uart_rx : process (clk_in)
  begin
    if rising_edge(clk_in) then
      case r_SM_Main is
 
        -- Case 1: Idle state
        when idle_state =>
          r_RX_DV     <= '0';
          clk_count <= 0;
          index <= 0;
          
          -- check when start bit is low
          if r_RX_Data = '0' then       -- start bit = '0'
            r_SM_Main <= get_start_bit;
          else
            r_SM_Main <= idle_state;
          end if;
           
        -- Case 2: Start bit state 
        -- checks for the start bit
        when get_start_bit =>
        -- checks if middle of start bit is low
          if clk_count = (clk_per_bit-1)/2 then
            -- then check if the start bit is low
            if r_RX_Data = '0' then
              -- reset the counter and go to the next state
              clk_count <= 0;
              r_SM_Main   <= get_bits;
            -- go to idle state
            else
              r_SM_Main   <= idle_state;
            end if;
          -- if middle state is not low, loop back to start bit state
          else
            clk_count <= clk_count + 1;
            r_SM_Main   <= get_start_bit;
          end if;
 
        -- Case 3: Begin receiving all 8 bits
        when get_bits =>
          if clk_count < clk_per_bit-1 then
            clk_count <= clk_count + 1;
            r_SM_Main   <= get_bits;
          else
            clk_count            <= 0;
            r_RX_Byte(index) <= r_RX_Data;
             
            -- Check if we have received all bits
            if index < 7 then
              index <= index + 1;
              r_SM_Main   <= get_bits;
            -- go to the next state to check for the stop bit
            else
              index <= 0;
              r_SM_Main   <= get_stop_bit;
            end if;
          end if;
 
        -- Case 4: Stop bit state
        -- check when stop bit is high
        when get_stop_bit =>
          if clk_count < clk_per_bit-1 then
            clk_count <= clk_count + 1;
            r_SM_Main   <= get_stop_bit;

          -- reset the count and stop bit goes high
          -- go to the next state 
          else
            r_RX_DV     <= '1';    -- stop bit
            clk_count <= 0;
            r_SM_Main   <= reset_state;
          end if;
 
        -- Case 5: reset state
        -- resets for one clock cycle
        when reset_state =>
          r_SM_Main <= idle_state;
          r_RX_DV   <= '0';
 
        when others =>
          r_SM_Main <= idle_state;
 
      end case;
    end if;
  end process p_uart_rx;
 
  tx_detect <= r_RX_DV;
  rx_start  <= r_RX_Byte;
   
end rtl;
