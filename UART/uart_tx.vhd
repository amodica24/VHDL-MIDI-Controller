-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the transmitter to send data 
--                   from the UART port of the FPGA to the computer
--
-- Inputs      :     i_Clk          - input clock
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
 
entity UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 320     -- = (10Mhz/31250)
    );
  port (
    -- inputs
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    --outputs
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end UART_TX;
 
 
architecture RTL of UART_TX is
 
  type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
                     s_TX_Stop_Bit, s_Reset);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
   
begin
 
   
  p_UART_TX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
         
      case r_SM_Main is
 
        -- Case 1: Idle state
        -- active bit input = '0' AND serial bit input = '1'
        when s_Idle =>
          o_TX_Active <= '0';        -- '0', idle
          o_TX_Serial <= '1';        -- '1', idle
          r_TX_Done   <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
          -- others <= '0'           -- sets the other inputs to '0'

          -- go to next state when enable is 1
          if i_TX_DV = '1' then
            r_TX_Data <= i_TX_Byte;
            r_SM_Main <= s_TX_Start_Bit;
          else
          -- else, stay in idle
            r_SM_Main <= s_Idle;
          end if;
        
        -- Case 2: Start Bit state
        -- active bit input = '1' and serial bit input = '0'
        when s_TX_Start_Bit =>
          o_TX_Active <= '1';         -- '1', active bit
          o_TX_Serial <= '0';         -- '0' = start bit
          
          -- check the end of the clk count to go to next state
          if (r_Clk_Count < g_CLKS_PER_BIT-1) then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Start_Bit;
          
            -- go to next state (Case 3)
          else
            r_Clk_Count <= 0;
            r_SM_Main   <= s_TX_Data_Bits;
          end if;
 
           
        -- Case 3: Data Bits state
        when s_TX_Data_Bits =>
          o_TX_Serial <= r_TX_Data(r_Bit_Index);   -- data bits
           
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Data_Bits;
          else
            r_Clk_Count <= 0;
             
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_TX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_TX_Stop_Bit;
            end if;
          end if;
 
        -- Case 4: Stop bit state
        -- stop bit = 1
        -- Stops the transmission of bits
        when s_TX_Stop_Bit =>
          o_TX_Serial <= '1';           -- '1', stop bit
 
          -- check the end of the clk count to go to next state
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Stop_Bit;
          
          -- once reached, go to the next state (Case 5)
          else
            r_TX_Done   <= '1';         -- '1', done transmitting all bits
            r_Clk_Count <= 0;           -- '0', reset clock count
            r_SM_Main   <= s_Reset;
          end if;
          
        -- Case 5: Reset state
        -- active bit = 0 AND done transmitting bit = 1
        when s_Reset =>
          o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_SM_Main   <= s_Idle;
           
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_TX;
 
  o_TX_Done <= r_TX_Done;
   
end RTL;
