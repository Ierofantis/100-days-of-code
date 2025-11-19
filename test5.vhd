library ieee;
use ieee.std_logic_1164.all;

-- Quartus top-level wrapper that instantiates sqrt4
entity test5 is
    port (
        a : in  std_logic_vector(3 downto 0);
        b : out std_logic_vector(2 downto 0)
    );
end entity test5;

architecture structural of test5 is
begin
    uut : entity work.sqrt4
        port map (
            a => a,
            b => b
        );
end architecture structural;
