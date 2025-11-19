library ieee;
use ieee.std_logic_1164.all;

-- 4-bit unsigned square-root with one fractional bit (0.5 resolution)
entity sqrt4 is
    port (
        a : in  std_logic_vector(3 downto 0);
        b : out std_logic_vector(2 downto 0)
    );
end entity sqrt4;

architecture rtl of sqrt4 is
    signal a0, a1, a2, a3 : std_logic;

    -- Intermediate inversions
    signal na2, na3       : std_logic;

    -- Shared ORs (limited to 2-input gates)
    signal or_a1_a0       : std_logic;
    signal or_a2_a1       : std_logic;
    signal or_a2a1_a0     : std_logic;

    -- B1 partial terms
    signal b1_term0       : std_logic;
    signal b1_term1       : std_logic;

    -- B0 partial terms
    signal b0_term0_a1    : std_logic;
    signal b0_term0       : std_logic;
    signal b0_term1_and   : std_logic;
    signal b0_term1_or    : std_logic;
    signal b0_term1       : std_logic;
    signal b0_term2_a2    : std_logic;
    signal b0_term2_a1    : std_logic;
    signal b0_term2       : std_logic;
    signal b0_or_01       : std_logic;
begin
    -- bit aliases
    a0 <= a(0);
    a1 <= a(1);
    a2 <= a(2);
    a3 <= a(3);

    na2 <= not a2;
    na3 <= not a3;

    or_a1_a0   <= a1 or a0;
    or_a2_a1   <= a2 or a1;
    or_a2a1_a0 <= or_a2_a1 or a0;

    -- B2 = A3 ∨ A2
    b(2) <= a3 or a2;

    -- B1 = (¬A2 ∧ (A1 ∨ A0)) ∨ (A3 ∧ (A2 ∨ A1 ∨ A0))
    b1_term0 <= na2 and or_a1_a0;
    b1_term1 <= a3 and or_a2a1_a0;
    b(1)     <= b1_term0 or b1_term1;

    -- B0 terms, chained through 2-input gates
    b0_term0_a1 <= na3 and a1;
    b0_term0    <= b0_term0_a1 and a0;

    b0_term1_and <= a3 and a2;
    b0_term1_or  <= a1 or a0;
    b0_term1     <= b0_term1_and and b0_term1_or;

    b0_term2_a2 <= a3 and na2;
    b0_term2_a1 <= b0_term2_a2 and (not a1);
    b0_term2    <= b0_term2_a1 and (not a0);

    b0_or_01 <= b0_term0 or b0_term1;
    b(0)     <= b0_or_01 or b0_term2;
end architecture rtl;
