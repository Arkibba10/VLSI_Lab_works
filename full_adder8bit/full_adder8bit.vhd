library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_8bit is
    Port ( A0, A1, A2, A3, A4, A5, A6, A7 : in  STD_LOGIC;
           B0, B1, B2, B3, B4, B5, B6, B7 : in  STD_LOGIC;
           Cin  : in  STD_LOGIC;
           S0, S1, S2, S3, S4, S5, S6, S7 : out STD_LOGIC;
           Cout : out STD_LOGIC);
end full_adder_8bit;

architecture Structural of full_adder_8bit is

    component full_adder1bit
        Port ( A    : in  STD_LOGIC;
               B    : in  STD_LOGIC;
               Cin  : in  STD_LOGIC;
               Sum  : out STD_LOGIC;
               Cout : out STD_LOGIC);
    end component;

    -- internal carries between stages
    signal c1, c2, c3, c4, c5, c6, c7 : STD_LOGIC;

begin

    FA0: full_adder1bit port map (A => A0, B => B0, Cin => Cin, Sum => S0, Cout => c1);
    FA1: full_adder1bit port map (A => A1, B => B1, Cin => c1,  Sum => S1, Cout => c2);
    FA2: full_adder1bit port map (A => A2, B => B2, Cin => c2,  Sum => S2, Cout => c3);
    FA3: full_adder1bit port map (A => A3, B => B3, Cin => c3,  Sum => S3, Cout => c4);
    FA4: full_adder1bit port map (A => A4, B => B4, Cin => c4,  Sum => S4, Cout => c5);
    FA5: full_adder1bit port map (A => A5, B => B5, Cin => c5,  Sum => S5, Cout => c6);
    FA6: full_adder1bit port map (A => A6, B => B6, Cin => c6,  Sum => S6, Cout => c7);
    FA7: full_adder1bit port map (A => A7, B => B7, Cin => c7,  Sum => S7, Cout => Cout);

end Structural;