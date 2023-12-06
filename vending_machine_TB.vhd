library ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY vending_machine_TB IS
END vending_machine_TB;
 
ARCHITECTURE behavior OF vending_machine_TB IS 
 
    -- Declararea componentelor pentru unitatea de test
 
    COMPONENT vending_machine
    PORT(
         nRST : IN  std_logic;
         clk : IN  std_logic;
         C : IN  std_logic;
         V : IN  std_logic_vector(7 downto 0);
         S0 : IN  std_logic_vector(7 downto 0);
         S1 : IN  std_logic_vector(7 downto 0);
         choice : IN  std_logic;
         P : OUT  std_logic_vector(7 downto 0);
         E : OUT  std_logic_vector(7 downto 0);
         D : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal nRST : std_logic := '0';
   signal clk : std_logic := '0';
   signal C : std_logic := '0';
   signal V : std_logic_vector(7 downto 0) := (others => '0');
   signal S0 : std_logic_vector(7 downto 0) := (others => '0');
   signal S1 : std_logic_vector(7 downto 0) := (others => '0');
   signal choice : std_logic := '0';

 	--Outputs
   signal P : std_logic_vector(7 downto 0);
   signal E : std_logic_vector(7 downto 0);
   signal D : std_logic_vector(1 downto 0);

   -- Definirea perioadei de ceas
   constant clk_period : time := 10 ns;
 
   constant S0price : std_logic_vector(7 downto 0) := "00000011"; --pret bautura 1 = 3 lei
   constant S1price : std_logic_vector(7 downto 0) := "00000101"; --pret bautura 2 = 5 lei
   
   constant un_leu : std_logic_vector(7 downto 0) := "00000001"; --bancnote de 1 leu
   constant cinci_lei : std_logic_vector(7 downto 0) := "00000101"; --bancnote de 5 lei
   constant zece_lei : std_logic_vector(7 downto 0) := "00001010"; --bancnote de 10 lei


BEGIN
 
	-- Instantiere UUT(Unit Under Test)
   uut: vending_machine PORT MAP (
          nRST => nRST,
          clk => clk,
          C => C,
          V => V,
          S0 => S0,
          S1 => S1,
          choice => choice,
          P => P,
          E => E,
          D => D
        );

   CLK <= not(CLK) after clk_period/2;
   nRST <= '0', '1' after 150 ns;  -- mentine starea de resetare pentru 400 ns.
   s0 <= S0price; --pret bautura 1 = 3 lei
   S1 <= S1price; --pret bautura 2 = 5 lei
   choice <= '1', '0' after 500 ns;
   C <= '0', '1' after 300 ns, '0' after 310 ns, '1'after 350ns, '0' after 360 ns,
             '1' after 400 ns, '0' after 410 ns, '1'after 450ns, '0' after 460 ns,
             '1' after 600 ns, '0' after 610 ns, '1'after 650ns, '0' after 660 ns,
             '1' after 700 ns, '0' after 710 ns;
   
   v <= (others => '0'), zece_lei after 290 ns, un_leu after 340 ns, cinci_lei after 400 ns, zece_lei after 440 ns,
   zece_lei after 600 ns, un_leu after 650 ns, cinci_lei after 700 ns, (others => '0') after 710 ns;
END;
