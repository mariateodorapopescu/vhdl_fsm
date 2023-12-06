--automat de bauturi
library ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity vending_machine is
	port(
		nRST : in std_logic;  --resetare negativa
		clk : in std_logic;
		C : in std_logic; --senzor bancnote: devine 1 cand detecteaza o bancnota
		V : in std_logic_vector(7 downto 0); --primeste valorea bancnotei de la senzor
		S0 : in std_logic_vector(7 downto 0); --pretul pentru prima bautura(acesta poate fi definit de proprietar)
		S1 : in std_logic_vector(7 downto 0); --pretul pentru a doua bautura(acesta poate fi definit de proprietar)
		choice : in std_logic; --alegere
		P : out std_logic_vector(7 downto 0); --ecran
		E : out std_logic_vector(7 downto 0); --rest
		D : out std_logic_vector(1 downto 0) --dispensare bautura
		);
end vending_machine;

architecture rtl of vending_machine is
component accumulator8 is
	port(
		clk: in std_logic;
		nRST_acc: in std_logic;
		C : in std_logic;	--devine 1 cand detecteaza o bancnota
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
		);
end component;

component subtractor8 is
	port(
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		result : out std_logic_vector(7 downto 0)
		);
end component;

component comparator8 is
	port(
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		g_out : out std_logic;
		e_out : out std_logic;
		l_out : out std_logic);
end component;

component mux21 is
	port(
		A : in std_logic_vector(7 downto 0);
		B : in std_logic_vector(7 downto 0);
		s : in std_logic;
		output : out std_logic_vector(7 downto 0)
		);
end component;

type FSMTYPE is (INIT_STATE, Coin_Reception, soda_dispensation);

signal CSTATE, NSTATE : FSMTYPE;
signal balance, price, price_reg, coins_to_return : std_logic_vector(7 downto 0);
signal price_choice_reg_EN, balance_greater, balance_equal, balance_lower: std_logic;
signal choice_reg, dispensation_EN : std_logic;
signal nRST_acc : std_logic;

begin
	price_registration : process( CLK )
    begin
        if (CLK'event and CLK = '1') then
            if (price_choice_reg_EN = '1') then
                price_reg <= price;
				choice_reg <= choice;
            end if ;
        end if ;
    end process ; --inregistrare pret


	state_registration : process( CLK )
    begin
        if (CLK'event and CLK = '1') then
            if (nRST = '0') then
                CSTATE <= INIT_STATE;
            else
                CSTATE <= NSTATE;
            end if ;
        end if ;
    end process ; --status

	soda_dispensation_proc: process(clk)
	begin
		if (CLK'event and CLK = '1') then
			if (dispensation_EN = '1') then
				if(choice_reg = '0') then
					D <= "01";	--S0
				else
					D <= "10";	--S1
				end if;
			else
				D <= "00";
			end if;
		end if;
	end process; --procesul de dispensare a bauturii

	next_state : process( CSTATE, balance, C, balance_equal, balance_greater, coins_to_return)
    begin
        NSTATE <= CSTATE;
		nRST_acc <= '1';
        price_choice_reg_EN <= '0';
		dispensation_EN <= '0';
		p <= (others => '0');
		E <= (others => '0');

        case( CSTATE ) is
            when INIT_STATE =>
				nRST_acc <= '0';
				price_choice_reg_EN <= '1';
				E <= balance;
                if (C = '1') then
					nRST_acc <= '1';
                    NSTATE <= Coin_Reception;
                end if ;
    
            when Coin_Reception =>
				P <= balance;
                if (balance_equal = '1' or balance_greater = '1') then
                    NSTATE <= soda_dispensation ;
                end if ;
            
            when soda_dispensation =>
				dispensation_EN <= '1';
				E <= coins_to_return;
				nRST_acc <= '0';
                NSTATE <= INIT_STATE;
    
            when others =>
        end case ;
    end process ; --urmatoarea stare

	mux : mux21 port map(S0, S1, choice, price);
	accumulator : accumulator8 port map (clk, nRST_acc, C, V, balance);
	comparator : comparator8 port map (balance, price_reg, balance_greater, balance_equal, balance_lower);
	subtractor : subtractor8 port map (balance, price_reg, coins_to_return);

end rtl;

