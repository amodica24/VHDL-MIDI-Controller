LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mult16_tb IS
END mult16_tb;
ARCHITECTURE behavioral OF mult16_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT mult16
    PORT(
    a   : IN std_logic;
    b   : IN std_logic;
    c   : IN std_logic;
    d   : IN std_logic;
    e1  : IN std_logic;
    f   : IN STD_LOGIC;
    g   : IN STD_LOGIC; 
    h   : IN STD_LOGIC;
    i   : IN STD_LOGIC; 
    j   : IN STD_LOGIC;
    k   : IN STD_LOGIC; 
    l   : IN STD_LOGIC;
    m   : IN STD_LOGIC; 
    n   : IN STD_LOGIC;
    o   : IN STD_LOGIC; 
    p   : IN STD_LOGIC;
    sel : in std_logic_vector(3 downto 0);
    
    q : OUT std_logic
    );
    END COMPONENT;
    --Inputs
    signal a_sig : std_logic ;
    signal b_sig : std_logic ;
    signal c_sig : std_logic;
    signal d_sig : std_logic;
    
    signal e_sig : std_logic ;
    signal f_sig : std_logic ;
    signal g_sig : std_logic;
    signal h_sig : std_logic;
    signal i_sig : std_logic ;
    signal j_sig : std_logic ;
    signal k_sig : std_logic;
    signal l_sig : std_logic;    
    signal m_sig : std_logic;
    signal n_sig : std_logic;
    signal o_sig : std_logic;
    signal p_sig : std_logic;
    signal sel_sig : std_logic_vector(3 downto 0);
    --Outputs
    signal q_sig : std_logic;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
  uut: mult16 PORT MAP (
    a => a_sig,
    b => b_sig,
    c => c_sig,
    d => d_sig,
    e1 => e_sig,
    f => f_sig,
    g => g_sig,
    h => h_sig,
    i => i_sig,
    j => j_sig,
    k => k_sig,
    l => l_sig,
    m => m_sig,
    n => n_sig,
    o => o_sig,
    p => p_sig,
    sel => sel_sig,
    q => q_sig
   );
-- Stimulus process
stim_proc: process
 begin
  a_sig <= '1';
  b_sig <= '0';
  c_sig <= '0';
  d_sig <= '0';
  e_sig <= '0';
  f_sig <= '0';
  g_sig <= '0';
  h_sig <= '0';
  i_sig <= '0';
  j_sig <= '0';
  k_sig <= '0';
  l_sig <= '0';
  m_sig <= '0';
  n_sig <= '0';
  o_sig <= '0';
  p_sig <= '0';
  sel_sig <= "0000";
  wait for 40 ns;
  sel_sig <= "0001"; 
  wait for 20 ns;
  b_sig <= '1';
  sel_sig <= "0001"; 
  wait for 40 ns;
  b_sig <= '0';
  sel_sig <= "0001";  
  wait for 30 ns; 
  c_sig <= '1';
  sel_sig <= "0010";
  wait;
  end process;
END;
