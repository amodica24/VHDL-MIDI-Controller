-----------------------------------------------------------------------------------
-- Project     :     VHDL MIDI Controller
-- Author      :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------------
-- File        :     uart_tx.vhd
-- Description :     This entity is the receiver that receives the message 
--                   being transmitted from the UART port of the FPGA
--
-- Inputs      :     i_Clk          - clock
--             :     i_RX_Serial    - transmit enable bit
-- Outputs     :     o_RX_DV        - bit for detecting bits are being transmitted
--             :     o_RX_Byte      - start bit
-----------------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 320     -- =(10Mhz/31250)
    );
  port (
    -- inputs
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    -- outputs
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end UART_RX;
 
 architecture rtl of UART_RX is
 
  type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
                     s_RX_Stop_Bit, s_Reset);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_RX_Data_R : std_logic := '0';
  signal r_RX_Data   : std_logic := '0';

  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
   
begin
 
  p_SAMPLE : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_RX_Data_R <= i_RX_Serial;
      r_RX_Data   <= r_RX_Data_R;
    end if;
  end process p_SAMPLE;
   
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      case r_SM_Main is
 
        -- Case 1: Idle state
        when s_Idle =>
          r_RX_DV     <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
          
          -- check when start bit is low
          if r_RX_Data = '0' then         -- start bit = '0'
            r_SM_Main <= s_RX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
           
        -- Case 2: Start bit state 
        when s_RX_Start_Bit =>
        -- checks if middle of start bit is low
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            -- then check if the start bit is low
            if r_RX_Data = '0' then
              -- reset the counter and go to the next state
              r_Clk_Count <= 0;
              r_SM_Main   <= s_RX_Data_Bits;
            -- go to idle state
            else
              r_SM_Main   <= s_Idle;
            end if;
          -- if middle state is not low, loop back to start bit state
          else
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Start_Bit;
          end if;
 
           
        -- Case 3: Data bits state
        when s_RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Data_Bits;
          else
            r_Clk_Count            <= 0;
            r_RX_Byte(r_Bit_Index) <= r_RX_Data;
             
            -- Check if we have received all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_RX_Data_Bits;
            -- go to the next state to check for the stop bit
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_RX_Stop_Bit;
            end if;
          end if;
 
        -- Case 4: Stop bit state
        -- check when stop bit is high
        when s_RX_Stop_Bit =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Stop_Bit;
          -- reset the count and stop bit goes high
          -- go to the next state 
          else
            r_RX_DV     <= '1';    -- stop bit
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Reset;
          end if;
 
        -- Case 5: reset state
        -- resets for one clock cycle
        when s_Reset =>
          r_SM_Main <= s_Idle;
          r_RX_DV   <= '0';
 
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_RX;
 
  o_RX_DV   <= r_RX_DV;
  o_RX_Byte <= r_RX_Byte;
   
end rtl;
