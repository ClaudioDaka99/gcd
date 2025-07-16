library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity gcd_tb is
end entity;

architecture tb of gcd_tb is

  constant clk_period : time     := 100 ns;
  constant N          : positive := 8;

  component gcd is
    generic (
      Nbit : positive := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        load : in std_logic;
        a_in : in std_logic_vector (Nbit-1 downto 0);
        b_in : in std_logic_vector (Nbit-1 downto 0);
        done : out std_logic;
        gcd_out : out std_logic_vector (Nbit-1 downto 0)
    );
  end component;

  signal clk_ext    : std_logic := '0';                                         -- clock signal, intialized to '0'
  signal a_ext      : std_logic_vector(N-1 downto 0) := (others => '0');        -- a signal to connect to the a_in port of the component
  signal b_ext      : std_logic_vector(N-1 downto 0) := (others => '0');        -- b signal to connect to the b_in port of the component
  signal rst_ext    : std_logic := '1';                                         -- reset signal
  signal load_ext   : std_logic := '0';                                         -- load signal to connect to the load port of the component: it is the input data valid
  signal gcd_ext    : std_logic_vector(N-1 downto 0);                           -- gcd signal to connect to the gcd_out port of the component
  signal done_ext   : std_logic := '0';                                         -- done signal to connect to the done port of the component: it is the output data valid
  signal testing    : boolean := true;                                          -- signal to use to start/stop the simulation when there is nothing else to test

begin
  
  clk_ext <= not clk_ext after clk_period/2 when testing else '0';  -- The clock toggles after clk_period / 2 when testing is high. 
                                                                    -- When testing is forced low, the clock stops toggling and the simulation ends.

DUT: gcd
    generic map (
      Nbit => N
    )
    port map (
        clk => clk_ext,
        rst => rst_ext,
        load => load_ext,
        a_in => a_ext,
        b_in => b_ext,
        done => done_ext,
        gcd_out => gcd_ext
    );

    stimuli: process
    begin
      --Initialization
      wait until rising_edge(clk_ext);
      rst_ext <= '0';
      wait until rising_edge(clk_ext);
      --1st test: MCD between 6 and 36 --> Desired output: 00000110 (6)
      rst_ext <= '1';
      a_ext    <= "00000110";
      b_ext    <= "00100100";
      load_ext <= '1';
      wait until falling_edge(done_ext);
      --Reset the device 
      rst_ext <= '0';
      a_ext <= (others => '0');
      b_ext <= (others => '0');
      load_ext <= '0';
      wait until rising_edge(clk_ext);
      --2nd test: MCD between 32 and 0 --> Desired output: 00100000 (32)
      rst_ext <= '1';
      a_ext    <= "00100000";
      b_ext    <= "00000000";
      load_ext <= '1';
      wait until falling_edge(done_ext);
      --Reset the device 
      rst_ext <= '0';
      a_ext <= (others => '0');
      b_ext <= (others => '0');
      load_ext <= '0';
      wait until rising_edge(clk_ext);
      --3rd test: MCD between 0 and 6 --> Desired output: 00000110 (6)
      rst_ext <= '1';
      a_ext    <= "00000000";
      b_ext    <= "00000110";
      load_ext <= '1';
      wait until falling_edge(done_ext);
      --Reset the device 
      rst_ext <= '0';
      a_ext <= (others => '0');
      b_ext <= (others => '0');
      load_ext <= '0';
      wait until rising_edge(clk_ext);
      --4th test: MCD between 0 and 0 --> Desired output: 00000000 (0)
      rst_ext <= '1';
      a_ext    <= "00000000";
      b_ext    <= "00000000";
      load_ext <= '1';
      wait until falling_edge(done_ext);
      --Reset the device 
      rst_ext <= '0';
      a_ext <= (others => '0');
      b_ext <= (others => '0');
      load_ext <= '0';
      wait until rising_edge(clk_ext);
      --5th test: MCD between 7 and 36 --> Desired output: 00000001 (1)
      rst_ext <= '1';
      a_ext    <= "00000111";
      b_ext    <= "00100100";
      load_ext <= '1';
      wait until falling_edge(done_ext);
      testing <= false;
    end process; 
end architecture;