library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity gcd is
    generic (
        Nbit : positive := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        load : in std_logic;
        a_in : in std_logic_vector (Nbit-1 downto 0);
        b_in : in std_logic_vector (Nbit-1 downto 0);
        done : out std_logic;
        gcd_out : out std_logic_vector (Nbit-1 downto 0)
    );
end entity;

architecture arch of gcd is 
    signal a : std_logic_vector (Nbit-1 downto 0 );
    signal b : std_logic_vector (Nbit-1 downto 0 );
    constant all_zeros : std_logic_vector(Nbit-1 downto 0) := (others => '0');

    begin 

    GCD_PROCESS: process(clk, rst)
        variable calc: std_logic;
        variable done_var: std_logic; 
        begin
            if rst = '0' then
                a <= (others => '0');
                b <= (others => '0');
                gcd_out <= (others => '0');
                done_var := '0';
                calc := '0';
            elsif rising_edge(clk) then
                done_var := '0';   
                if load = '1' and calc = '0' then
                    a <= a_in;
                    b <= b_in;
                    calc := '1';
                elsif calc = '1' then
                    if a = b then
                        gcd_out <= a;
                        done_var := '1';
                        calc := '0';
                    elsif a = all_zeros then 
                        gcd_out <= b;
                        done_var := '1';
                        calc := '0';
                    elsif b = all_zeros then 
                        gcd_out <= a;
                        done_var := '1';
                        calc := '0';    
                    elsif a < b then 
                        b <= b - a;
                    else 
                        a <= a - b;
                    end if;
                end if;
            end if;                     
            done <= done_var;
    end process GCD_PROCESS;
end arch;            