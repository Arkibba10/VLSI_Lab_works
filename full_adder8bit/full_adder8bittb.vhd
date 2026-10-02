
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY full_adder8bittb IS
END full_adder8bittb;
 
ARCHITECTURE behavior OF full_adder8bittb IS 
 
    COMPONENT full_adder_8bit
    PORT(
         A0 : IN  std_logic;
         A1 : IN  std_logic;
         A2 : IN  std_logic;
         A3 : IN  std_logic;
         A4 : IN  std_logic;
         A5 : IN  std_logic;
         A6 : IN  std_logic;
         A7 : IN  std_logic;
         B0 : IN  std_logic;
         B1 : IN  std_logic;
         B2 : IN  std_logic;
         B3 : IN  std_logic;
         B4 : IN  std_logic;
         B5 : IN  std_logic;
         B6 : IN  std_logic;
         B7 : IN  std_logic;
         Cin : IN  std_logic;
         S0 : OUT  std_logic;
         S1 : OUT  std_logic;
         S2 : OUT  std_logic;
         S3 : OUT  std_logic;
         S4 : OUT  std_logic;
         S5 : OUT  std_logic;
         S6 : OUT  std_logic;
         S7 : OUT  std_logic;
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A0 : std_logic := '0';
   signal A1 : std_logic := '0';
   signal A2 : std_logic := '0';
   signal A3 : std_logic := '0';
   signal A4 : std_logic := '0';
   signal A5 : std_logic := '0';
   signal A6 : std_logic := '0';
   signal A7 : std_logic := '0';
   signal B0 : std_logic := '0';
   signal B1 : std_logic := '0';
   signal B2 : std_logic := '0';
   signal B3 : std_logic := '0';
   signal B4 : std_logic := '0';
   signal B5 : std_logic := '0';
   signal B6 : std_logic := '0';
   signal B7 : std_logic := '0';
   signal Cin : std_logic := '0';

 	--Outputs
   signal S0 : std_logic;
   signal S1 : std_logic;
   signal S2 : std_logic;
   signal S3 : std_logic;
   signal S4 : std_logic;
   signal S5 : std_logic;
   signal S6 : std_logic;
   signal S7 : std_logic;
   signal Cout : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder_8bit PORT MAP (
          A0 => A0,
          A1 => A1,
          A2 => A2,
          A3 => A3,
          A4 => A4,
          A5 => A5,
          A6 => A6,
          A7 => A7,
          B0 => B0,
          B1 => B1,
          B2 => B2,
          B3 => B3,
          B4 => B4,
          B5 => B5,
          B6 => B6,
          B7 => B7,
          Cin => Cin,
          S0 => S0,
          S1 => S1,
          S2 => S2,
          S3 => S3,
          S4 => S4,
          S5 => S5,
          S6 => S6,
          S7 => S7,
          Cout => Cout
        );
 
   stim_proc: process
   begin		
	
    --  0 + 0 + 0 = 0
    a0<='0'; a1<='0'; a2<='0'; a3<='0'; a4<='0'; a5<='0'; a6<='0'; a7<='0';
    b0<='0'; b1<='0'; b2<='0'; b3<='0'; b4<='0'; b5<='0'; b6<='0'; b7<='0';
    cin<='0';
    wait for 20 ns;

    --  0F + 01 = 10
    a0<='1'; a1<='1'; a2<='1'; a3<='1'; a4<='0'; a5<='0'; a6<='0'; a7<='0';
    b0<='1'; b1<='0'; b2<='0'; b3<='0'; b4<='0'; b5<='0'; b6<='0'; b7<='0';
    cin<='0';
    wait for 20 ns;

    --  7F + 01 = 80
    a0<='1'; a1<='1'; a2<='1'; a3<='1'; a4<='1'; a5<='1'; a6<='1'; a7<='0';
    b0<='1'; b1<='0'; b2<='0'; b3<='0'; b4<='0'; b5<='0'; b6<='0'; b7<='0';
    cin<='0';
    wait for 20 ns;

    --  3C + 4B = 87
    a0<='0'; a1<='0'; a2<='1'; a3<='1'; a4<='1'; a5<='1'; a6<='0'; a7<='0';
    b0<='1'; b1<='1'; b2<='0'; b3<='1'; b4<='0'; b5<='0'; b6<='1'; b7<='0';
    cin<='0';
    wait for 20 ns;

    --  12 + 34 + 1 = 47
    a0<='0'; a1<='1'; a2<='0'; a3<='0'; a4<='1'; a5<='0'; a6<='0'; a7<='0';
    b0<='0'; b1<='0'; b2<='1'; b3<='0'; b4<='1'; b5<='1'; b6<='0'; b7<='0';
    cin<='1';
    wait for 20 ns;

    --  55 + AA = FF
    a0<='1'; a1<='0'; a2<='1'; a3<='0'; a4<='1'; a5<='0'; a6<='1'; a7<='0';
    b0<='0'; b1<='1'; b2<='0'; b3<='1'; b4<='0'; b5<='1'; b6<='0'; b7<='1';
    cin<='0';
    wait for 20 ns;

    --  55 + AA + 1 = 100 (S=00, Cout=1)
    a0<='1'; a1<='0'; a2<='1'; a3<='0'; a4<='1'; a5<='0'; a6<='1'; a7<='0';
    b0<='0'; b1<='1'; b2<='0'; b3<='1'; b4<='0'; b5<='1'; b6<='0'; b7<='1';
    cin<='1';
    wait for 20 ns;

    --  FF + 01 = 100 (S=00, Cout=1)
    a0<='1'; a1<='1'; a2<='1'; a3<='1'; a4<='1'; a5<='1'; a6<='1'; a7<='1';
    b0<='1'; b1<='0'; b2<='0'; b3<='0'; b4<='0'; b5<='0'; b6<='0'; b7<='0';
    cin<='0';
    wait for 20 ns;

    --  FF + FF + 1 = 1FF (S=FF, Cout=1)
    a0<='1'; a1<='1'; a2<='1'; a3<='1'; a4<='1'; a5<='1'; a6<='1'; a7<='1';
    b0<='1'; b1<='1'; b2<='1'; b3<='1'; b4<='1'; b5<='1'; b6<='1'; b7<='1';
    cin<='1';
    wait for 20 ns;

      wait;
   end process;

END;
