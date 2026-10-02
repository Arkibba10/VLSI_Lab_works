
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_addertb IS
END full_addertb;
 
ARCHITECTURE behavior OF full_addertb IS 
 
    COMPONENT full_adder
    PORT(
         A : IN  std_logic;
         B : IN  std_logic;
         Cin : IN  std_logic;
         Sum : OUT  std_logic;
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic := '0';
   signal B : std_logic := '0';
   signal Cin : std_logic := '0';

 	--Outputs
   signal Sum : std_logic;
   signal Cout : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder PORT MAP (
          A => A,
          B => B,
          Cin => Cin,
          Sum => Sum,
          Cout => Cout
        );
		  
   stim_proc: process
   begin		
        a <= '0'; b <= '0'; cin <= '0'; wait for 50 ns;
        a <= '0'; b <= '0'; cin <= '1'; wait for 50 ns;
        a <= '0'; b <= '1'; cin <= '0'; wait for 50 ns;
        a <= '0'; b <= '1'; cin <= '1'; wait for 50 ns;
        a <= '1'; b <= '0'; cin <= '0'; wait for 50 ns;
        a <= '1'; b <= '0'; cin <= '1'; wait for 50 ns;
        a <= '1'; b <= '1'; cin <= '0'; wait for 50 ns;
        a <= '1'; b <= '1'; cin <= '1'; wait for 50 ns;
      wait;
   end process;

END;
