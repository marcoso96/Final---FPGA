----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:18 09/18/2018 
-- Design Name: 
-- Module Name:    Maquinola - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Maquinola is

	port(
	
		clk, reset:in std_logic;
		start: in std_logic;
		done: out std_logic
	
	);
	
end Maquinola;

architecture Behavioral of Maquinola is
	
	type state_type is (idle, hecho, espera); 
	signal state_reg, state_next: state_type;

begin
	
	process(clk,reset)
	
	begin
		if (reset='1' ) then
			
			
			state_reg <= idle;
		
		elsif (clk'event and clk='1') then
		
			state_reg<=state_next;
			
		end if;
	end process;

	
	process (state_reg, start)
   begin
      
      state_next<=state_reg;  -- default is to stay in current state
     
      case (state_reg) is
			
         when idle =>
            
				if start= '1' then
            
					state_next <= hecho;
            
				end if;
				
         when hecho =>
				
				state_next<=espera;
         
			when espera =>
            
				if start = '0' then 
				
					state_next<=idle;
				
				end if;
				
      end case;      
   end process;

	process(state_reg)
		begin 
		
			if (state_reg = hecho) then
			
				done<='1';
			
			else done<='0';
			
			end if;
	end process;
	
end Behavioral;
	
