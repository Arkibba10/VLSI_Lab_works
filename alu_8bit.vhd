library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- 8-bit ALU
-- OP  operation        RESULT
-- 000 ADD              A + B
-- 001 SUB              A - B   (A + not B + 1)
-- 010 AND              A and B
-- 011 OR               A or B
-- 100 XOR              A xor B
-- 101 NOT              not A
-- 110 INC              A + 1
-- 111 DEC              A - 1   (A + FF)
--
-- Flags: ZERO (result = 0), CARRY (carry-out of adder, arithmetic ops only;
--        for SUB, CARRY = 1 means no borrow), NEG (MSB of result),
--        OVF (signed overflow, arithmetic ops only)
entity alu_8bit is
    Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           OP     : in  STD_LOGIC_VECTOR (2 downto 0);
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           ZERO   : out STD_LOGIC;
           CARRY  : out STD_LOGIC;
           NEG    : out STD_LOGIC;
           OVF    : out STD_LOGIC);
end alu_8bit;
architecture Structural of alu_8bit is
    component adder_8bit
        Port ( A    : in  STD_LOGIC_VECTOR (7 downto 0);
               B    : in  STD_LOGIC_VECTOR (7 downto 0);
               CIN  : in  STD_LOGIC;
               SUM  : out STD_LOGIC_VECTOR (7 downto 0);
               COUT : out STD_LOGIC);
    end component;
    signal b_eff    : STD_LOGIC_VECTOR (7 downto 0);  -- operand fed to adder
    signal cin_eff  : STD_LOGIC;                      -- carry-in fed to adder
    signal sum      : STD_LOGIC_VECTOR (7 downto 0);
    signal cout_add : STD_LOGIC;
    signal arith    : STD_LOGIC;                      -- '1' for ADD/SUB/INC/DEC
    signal res      : STD_LOGIC_VECTOR (7 downto 0);
begin
    -- 1) choose what the adder sees as second operand and carry-in
    with OP select
        b_eff <= B          when "000",   -- ADD
                 not B      when "001",   -- SUB
                 x"00"      when "110",   -- INC
                 x"FF"      when "111",   -- DEC
                 x"00"      when others;  -- logic ops (don't care)
    with OP select
        cin_eff <= '1' when "001",        -- SUB
                   '1' when "110",        -- INC
                   '0' when others;
    -- 2) the adder we already built
    ADDER: adder_8bit port map (
        A => A, B => b_eff, CIN => cin_eff,
        SUM => sum, COUT => cout_add
    );
    -- 3) pick the result
    with OP select
        res <= sum      when "000" | "001" | "110" | "111",
               A and B  when "010",
               A or B   when "011",
               A xor B  when "100",
               not A    when "101",
               x"00"    when others;
    arith <= '1' when (OP = "000" or OP = "001" or OP = "110" or OP = "111") else '0';
    -- 4) outputs and flags
    RESULT <= res;
    ZERO   <= '1' when res = x"00" else '0';
    NEG    <= res(7);
    CARRY  <= cout_add and arith;
    OVF    <= arith and (not (A(7) xor b_eff(7))) and (A(7) xor res(7));
end Structural;
