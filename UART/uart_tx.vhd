-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the transmitter to send data 
--                   from the UART port of the FPGA to the computer
--
-- Inputs      :     clk_in          - input clock
--             :     i_TX_DV        - transmit enable bit
--             :     i_TX_Byte      - the 8 bits being transmitted
-- Outputs     :     o_TX_Active    - bit for detecting bits are being transmitted
--             :     o_TX_Serial    - start bit
--             :     o_TX_Done      - bit detects when done transmitting
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
    clk_in       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    --outputs
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end uart_tx;
 
 
architecture RTL of uart_tx is
 
  type t_SM_Main is (idle_state, s_TX_Start_Bit, s_TX_Data_Bits,
                     s_TX_Stop_Bit, reset_state);
  signal r_SM_Main : t_SM_Main := idle_state;
 
  signal clk_count : integer range 0 to clk_per_bit-1 := 0;
  signal index : integer range 0 to 7 := 0;  
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
   
begin
 
   
  p_uart_tx : process (clk_in)
  begin
    if rising_edge(clk_in) then
         
      case r_SM_Main is
 
        -- Case 1: Idle state
        -- active bit input = '0' AND serial bit input = '1'
        when idle_state =>
          o_TX_Active <= '0';        -- '0', idle
          o_TX_Serial <= '1';        -- '1', idle
          r_TX_Done   <= '0';
          clk_count <= 0;
          index <= 0;
          -- others <= '0'           -- sets the other inputs to '0'

          -- go to next state when enable is 1
          if i_TX_DV = '1' then
            r_TX_Data <= i_TX_Byte;
            r_SM_Main <= s_TX_Start_Bit;
          else
          -- else, stay in idle
            r_SM_Main <= idle_state;
          end if;
        
        -- Case 2: Start Bit state
        -- active bit input = '1' and serial bit input = '0'
        when s_TX_Start_Bit =>
          o_TX_Active <= '1';         -- '1', active bit
          o_TX_Serial <= '0';         -- '0' = start bit
          
          -- check the end of the clk count to go to next state
          if (clk_count < clk_per_bit-1) then
            clk_count <= clk_count + 1;
            r_SM_Main   <= s_TX_Start_Bit;
          
            -- go to next state (Case 3)
          else
            clk_count <= 0;
            r_SM_Main   <= s_TX_Data_Bits;
          end if;
 
           
        -- Case 3: Data Bits state
        when s_TX_Data_Bits =>
          o_TX_Serial <= r_TX_Data(index);   -- data bits
           
          if clk_count < clk_per_bit-1 then
            clk_count <= clk_count + 1;
            r_SM_Main   <= s_TX_Data_Bits;
          else
            clk_count <= 0;
             
            -- Check if we have sent out all bits
            if index < 7 then
              index <= index + 1;
              r_SM_Main   <= s_TX_Data_Bits;
            else
              index <= 0;
              r_SM_Main   <= s_TX_Stop_Bit;
            end if;
          end if;
 
        -- Case 4: Stop bit state
        -- stop bit = 1
        -- Stops the transmission of bits
        when s_TX_Stop_Bit =>
          o_TX_Serial <= '1';           -- '1', stop bit
 
          -- check the end of the clk count to go to next state
          if clk_count < clk_per_bit-1 then
            clk_count <= clk_count + 1;
            r_SM_Main   <= s_TX_Stop_Bit;
          
          -- once reached, go to the next state (Case 5)
          else
            r_TX_Done   <= '1';         -- '1', done transmitting all bits
            clk_count <= 0;           -- '0', reset clock count
            r_SM_Main   <= reset_state;
          end if;
          
        -- Case 5: Reset state
        -- active bit = 0 AND done transmitting bit = 1
        when reset_state =>
          o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_SM_Main   <= idle_state;
           
        when others =>
          r_SM_Main <= idle_state;
 
      end case;
    end if;
  end process p_uart_tx;
 
  o_TX_Done <= r_TX_Done;
   
end RTL;
