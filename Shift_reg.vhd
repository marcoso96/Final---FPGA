----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:55:05 09/26/2018 
-- Design Name: 
-- Module Name:    Shift_reg - Behavioral 
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
use work.Filtro_pckg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shift_reg is
	
	generic (N: natural :=20;
				N_idx : natural :=5
	);
	
	port(
		
		clk, reset : in std_logic;
		data : in std_logic_vector(Bits_x_t-1 downto 0);
		data_new: out x_t (N downto 0);
		
		start : in std_logic;
		done: out std_logic
	);
	
end Shift_reg;

architecture Behavioral of Shift_reg is
	
	type state_type is (idle, espera, joya);
	signal state_reg, state_next: state_type;
	signal info_reg, info_next: x_t(0 to N);

begin
		
	process(clk, reset) 
	begin
		
		if(reset='1') then 
			
			info_reg <= (others => (others => '0'));
			state_reg <= idle;
			
		elsif(clk'event and clk = '1') then 
		
			info_reg <= info_next;
			state_reg <= state_next;
						
		end if;
	end process;
	
	--logica de estado siguiente
	
	process(info_reg, state_reg, start, data)
	begin 
		
		state_next <= state_reg;
		info_next <= info_reg;
		
		case(state_reg) is 
			
			when idle =>

				if(start = '1') then
					
					state_next <= espera;
										
				end if;
				
			when espera =>
				
				info_next <= data & info_reg (0 to N-1);
				state_next <= joya;
				
			when joya =>
			
				state_next <= idle;
								
		end case; 
	end process;
	
	--logica de la salida
	
	process(state_reg, start, info_reg)
	begin 
	
	data_new <= info_reg;
	done <= '0';
		
		case(state_reg) is 
			
			when idle =>
			
			when espera =>
			
			when joya =>
				
				done <= '1';
			
		end case;		
	end process;
	
end Behavioral;

