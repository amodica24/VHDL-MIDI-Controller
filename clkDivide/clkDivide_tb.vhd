Library IEEE;
USE IEEE.std_logic_1164.ALL;

entity clkDivide_tb is
end clkDivide_tb;

architecture behavior of clkDivide_tb is

component clkDivide
port(
	clk_in   : in std_logic;
	clk_rst  : in std_logic;
	new_clk  : out std_logic
	);
end component;

-- inputs
signal clk_in  : std_logic := '0';
signal clk_rst : std_logic := '0';

-- outputs
signal new_clk : std_logic;

-- clock period
constant clk_period : time := 10 ns; -- insert the clk period being used

begin
    -- Instantiate the Unit Under Test (UUT)
  uut: clkDivide PORT MAP (
    clk_in => clk_in_s,
    clk_rst => clk_rst_s,
    new_clk => new_clk_s
   );

-- clock process
clk_process : process
   begin
      clk_in_s <= '0';
      wait for clk_period/2;
      clk_in_s <= '1';
      wait for clk_period/2;
   end process;

-- stimulus process
stim_proc: process
   begin
   wait for 200ns;
   clk_rst_s <= '1';
   wait for 200ns;
   clk_rst_s <= '0';
end process

end;
