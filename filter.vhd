----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:53 09/19/2018 
-- Design Name: 
-- Module Name:    filter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.Filtro_pckg.all;

entity filter is

	generic (N: natural :=20;
				N_idx : natural :=5
	);
	
	port(
		
		clk, reset : in std_logic;
		
		a : in x_t(0 to N);
		cte: in cte_t(0 to N);
		start : in std_logic;
		
		
		result : out std_logic_vector(Bits_x_t-1 downto 0); 
		done : out std_logic
	);
	
end filter;

architecture Behavioral of filter is

	type state_type is (idle, multiplica, suma, joya); 
	
	signal state_reg, state_next: state_type;
	signal i_reg, i_next: unsigned(N_idx downto 0);
	signal suma_reg, suma_next: signed(2*(N+Bits_x_t)+1 downto 0);
	signal mult_reg, mult_next: signed(2*(N+Bits_x_t)+1 downto 0);
	
begin
	
	
	process(clk, reset) 
	begin
		
		if(reset='0') then 
			
			i_reg <= (others => '0');
			state_reg <= idle;
			suma_reg <= (others => '0');
			mult_reg <= (others => '0');
			
		elsif(clk'event and clk = '1') then 
		
			i_reg <= i_next;
			state_reg <= state_next;
			suma_reg <= suma_next;
			mult_reg <= mult_next;
			
		end if;
	end process;
	
	
	--logica de estado siguiente
	process(suma_reg, mult_reg, state_reg, i_reg)
	begin 
		
		state_next <= state_reg;
		mult_next <= mult_reg;
		suma_next <= suma_reg;
		i_next <= i_reg;
		
		case(state_reg) is 
			
			when idle =>
				
				if(start = '1') then
					
					state_next <= multiplica;
				
				end if;
			
			when multiplica =>
				
				if (i_reg <= to_unsigned(N, N_idx) ) then 
					
					--ya esta shifteado		
					mult_next <= (signed(a(to_integer(i_reg))) *  signed(cte(to_integer(i_reg))));		
					
				end if;
				
				state_next <= suma;
			
			when suma =>
				
				if (i_reg <= to_unsigned(N, N_idx) ) then 
					
					--ya esta shifteado		
					suma_next <= suma_reg + mult_reg;		
					state_next <= multiplica;
					i_next <= i_reg + 1;
				
				else 
				
					suma_next <= suma_reg + mult_reg;		
					state_next <= joya;
				
				end if;
				
				
			when joya => 
				
				state_next <= idle;
				
		end case;
			
	end process;
	
	process(state_reg)
	begin
		
			done <= '0';
			result <= (others => '0');
			
			if (state_reg = joya) then 
				
				done <= '1';
				result <= std_logic_vector(suma_next(47 downto 40)); 
				
			else done <= '0';
			
			end if;
			
	end process;
	
	
end Behavioral;

