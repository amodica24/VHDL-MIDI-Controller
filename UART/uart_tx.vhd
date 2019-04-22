-----------------------------------------------------------------------------
-- Project	    :     VHDL MIDI Controller
-- Author  	    :     Anthony Modica, Blaine Rieger, Brian Palmigiano
-----------------------------------------------------------------------------
-- File		    :     uart_tx.vhd
-- Description  :     This entity is the transmitter to send data 
--             	      from the UART port of the FPGA to the computer
-- 		
-- Inputs       :     fill in these  - fill in these
--		        :     fill in these  - fill in these
--		        :     fill in these  - fill in these
-- Outputs	    :     fill in these  - fill in these
--              :     fill in these  - fill in these
--              :     fill in these  - fill in these
-----------------------------------------------------------------------------
-- Version/Notes
-- 1.0 - 2019-04-29 - Initial Version
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    generic (
    -- Clock cycles = frequency of in_clk/frequency of uart
    -- frequency is 1 GHz/115200
    clk_cycles_bit : integer := 320
    );

    port(
        -- inputs
        in_clk      :  in    std_logic;                       -- input clock
        tx_byte     :  in    std_logic_vector(7 downto 0);    -- transceiver byte data
        tx_enable   :  in    std_logic;                       -- tx enable
        -- outputs
        tx_active   :  out   std_logic;                       -- if the transceiver is sending data
        tx_done     :  out   std_logic;                       -- transceiver is done sending data
        tx_serial   :  out   std_logic;                       -- transceiver serial
        tx_active
        );
    end uart_tx;

    architecture RTL of uart_tx is
        type tx_process is (idle_state, tx_start, tx_data, tx_stop);

        signal rx_process  : tx_process := idle_state;

        signal clk_count   : integer range 0 to clk_cycles_bit-1 := 0;
        signal bit_index   : integer std_logic_vector(0 to 7);    -- keep track of the bit index
        signal rx_tx_data  : std_logic_vector(7 downto 0);        -- transmits from MSB to LSB
        signal r_TX_Done   : std_logic := '0';                    -- signals when rx is done receiving data


        begin   
            p_uart_tx : process (in_clk)
            begin
                if rising_edge(in_clk) then
                    case rx_process is
                        
                        -- Case 1: IDLE state
                        when idle_state =>
                            tx_active   <= '0';
                            tx_serial   <= '1';         -- Drive Line High for Idle
                            r_TX_Done   <= '0';
                            clk_count   <= 0;
                            bit_index   <= 0;
               
                            if i_TX_DV = '1' then       -- if enable is high, go to next state
                                rx_tx_data <= i_TX_Byte;
                                rx_process <= tx_start;
                            else
                                rx_process <= idle_state;
                            end if;

                        -- Case 2: Start Tx transmission state
                        when tx_start =>
                            tx_active <= '1';  
                            tx_serial <= '0';     -- start bit is 0

                            if clk_count < clk_cycles_bit-1 then -- checks the end of the clock cycle
                                clk_count <= clk_count + 1;      
                                rx_process <= tx_start;          -- continue transmitting data
                              else
                                clk_count <= 0;                  -- once at the end of the cycle,
                                rx_process <= tx_data;           -- go to the next state
                            end if;

                        -- Case 3: data state
                        when tx_data => 
                                tx_serial <= rx_tx_data(bit_index)

                                if clk_count < clk_cycles_bit-1 then
                                    clk_count <= clk_count + 1;
                                    rx_process <= tx_start;
                                    rx_process <= tx_data;
                                else 
                                clk_count <=0;
                                
                                if bit_index < 7 then             -- check if all data has been sent
                                    clk_count <= clk_count + 1;
                                    rx_process <= tx_data;        -- continue checking
                                else 
                                    bit_index <= 0;               -- once at the end of the index,
                                    rx_process <= tx_stop;        -- go to the next state
                                end if;
                            end if;

                        -- case 4: stop state
                        when tx_stop =>
                                    tx_serial <= '1';
                                    if clk_count < clk_cycles_bit-1 then
                                        clk_count  <= clk_count + 1;
                                        rx_process <= tx_stop
                                      else
                                        r_TX_Done  <= '1';
                                        clk_count  <= 0;
                                        rx_process <= tx_idle;
                                    end if;
                    end case;
                end if;
            end process p_uart_tx;
        end RTL;
                                      
