library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity alu_8bit_tb is
end alu_8bit_tb;
architecture Behavioral of alu_8bit_tb is
    component alu_8bit
        Port ( A      : in  STD_LOGIC_VECTOR (7 downto 0);
               B      : in  STD_LOGIC_VECTOR (7 downto 0);
               OP     : in  STD_LOGIC_VECTOR (2 downto 0);
               RESULT : out STD_LOGIC_VECTOR (7 downto 0);
               ZERO   : out STD_LOGIC;
               CARRY  : out STD_LOGIC;
               NEG    : out STD_LOGIC;
               OVF    : out STD_LOGIC);
    end component;
    signal A_tb, B_tb, RES_tb : STD_LOGIC_VECTOR (7 downto 0);
    signal OP_tb              : STD_LOGIC_VECTOR (2 downto 0);
    signal Z_tb, C_tb, N_tb, V_tb : STD_LOGIC;
    -- helper: signed value of a byte given as integer 0..255
    function sgn(x : integer) return integer is
    begin
        if x >= 128 then return x - 256; else return x; end if;
    end function;
begin
    UUT: alu_8bit port map ( A => A_tb, B => B_tb, OP => OP_tb,
                             RESULT => RES_tb, ZERO => Z_tb, CARRY => C_tb,
                             NEG => N_tb, OVF => V_tb );
    stim_proc: process
        variable exp_res : integer;
        variable exp_c   : std_logic;
        variable exp_v   : std_logic;
        variable s       : integer;
        variable errors  : integer := 0;
        variable a, b    : integer;
        procedure check (op : integer; a : integer; b : integer) is
        begin
            A_tb  <= std_logic_vector(to_unsigned(a, 8));
            B_tb  <= std_logic_vector(to_unsigned(b, 8));
            OP_tb <= std_logic_vector(to_unsigned(op, 3));
            wait for 10 ns;
            exp_c := '0'; exp_v := '0';
            case op is
                when 0 => -- ADD
                    exp_res := (a + b) mod 256;
                    if a + b > 255 then exp_c := '1'; end if;
                    s := sgn(a) + sgn(b);
                    if s > 127 or s < -128 then exp_v := '1'; end if;
                when 1 => -- SUB
                    exp_res := (a - b + 256) mod 256;
                    if a >= b then exp_c := '1'; end if;   -- 1 = no borrow
                    s := sgn(a) - sgn(b);
                    if s > 127 or s < -128 then exp_v := '1'; end if;
                when 2 => exp_res := to_integer(unsigned(std_logic_vector(to_unsigned(a,8)) and std_logic_vector(to_unsigned(b,8))));
                when 3 => exp_res := to_integer(unsigned(std_logic_vector(to_unsigned(a,8)) or  std_logic_vector(to_unsigned(b,8))));
                when 4 => exp_res := to_integer(unsigned(std_logic_vector(to_unsigned(a,8)) xor std_logic_vector(to_unsigned(b,8))));
                when 5 => exp_res := 255 - a;
                when 6 => -- INC
                    exp_res := (a + 1) mod 256;
                    if a = 255 then exp_c := '1'; end if;
                    if sgn(a) + 1 > 127 then exp_v := '1'; end if;
                when others => -- DEC
                    exp_res := (a - 1 + 256) mod 256;
                    if a >= 1 then exp_c := '1'; end if;
                    if sgn(a) - 1 < -128 then exp_v := '1'; end if;
            end case;
            if to_integer(unsigned(RES_tb)) /= exp_res or C_tb /= exp_c or V_tb /= exp_v
               or (Z_tb = '1') /= (exp_res = 0) or (N_tb = '1') /= (exp_res >= 128) then
                errors := errors + 1;
                report "FAIL: op=" & integer'image(op) & " A=" & integer'image(a) &
                       " B=" & integer'image(b) & " got=" &
                       integer'image(to_integer(unsigned(RES_tb))) &
                       " exp=" & integer'image(exp_res) severity error;
            end if;
        end procedure;
    begin
        -- directed corner cases
        for op in 0 to 7 loop
            check(op, 0,   0);
            check(op, 255, 255);
            check(op, 127, 1);     -- +127 + 1  -> signed overflow on ADD
            check(op, 128, 1);     -- -128 - 1  -> signed overflow on SUB/DEC
            check(op, 255, 1);     -- carry / wrap
            check(op, 5,   10);    -- borrow on SUB
            check(op, 85,  170);   -- 55 / AA
        end loop;
        -- sweep: every opcode over a grid of A,B values
        for op in 0 to 7 loop
            a := 0;
            while a <= 255 loop
                b := 0;
                while b <= 255 loop
                    check(op, a, b);
                    b := b + 15;
                end loop;
                a := a + 15;
            end loop;
        end loop;
        if errors = 0 then
            report "PASS: alu_8bit testbench completed, 0 errors" severity note;
        else
            report "FAILED: " & integer'image(errors) & " mismatches" severity failure;
        end if;
        wait;
    end process;
