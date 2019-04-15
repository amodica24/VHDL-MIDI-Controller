library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_tx_tb is
end uart_tx_tb;

architecture behave of uart_tx is
    component uart_tx is
        generic (
            clk_cycles_bit : integer := 320
            );
        port (
            in_clk       : in  std_logic;
            tx_enable    : in  std_logic;
            tx_byte      : in  std_logic_vector(7 downto 0);
            tx_active    : out std_logic;
            tx_serial    : out std_logic;
            tx_done      : out std_logic
            );
        );
    end component uart_tx;

begin
 
    -- Instantiate UART transmitter
    UART_TX_INST : uart_tx
      generic map (
        clk_cycles_bit => s_clk_cycles_bit
        )
      port map (
        in_clk     =>   s_in_clk,
        tx_enable  =>   s_tx_enable,
        tx_byte    =>   s_tx_byte,
        tx_serial  =>   s_tx_serial,
        tx_done    =>   s_tx_done
        );
     
    -- clock process
    process(clk)
        begin
            if (rising_edge(clk)) then -- start at rising edge
                
            
            
            
            end if;

        
