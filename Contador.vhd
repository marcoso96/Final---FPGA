----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:50:06 10/09/2018 
-- Design Name: 
-- Module Name:    Contador - Behavioral 
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

entity Contador_20k is
	
	generic (DBIT: integer:=8);
	
	port(
		
		CLK, RESET : in std_logic;
		start : out std_logic
		--wr_uart: out std_logic
	);

end Contador_20k;

architecture Behavioral of Contador_20k is

	signal reloj_reg, reloj_next: unsigned(12 downto 0);
	
begin

	process(CLK, RESET)
	begin
	
		if (RESET = '1') then 
			
			reloj_reg <= (others => '0');
		
		elsif (CLK'event and CLK = '1') then 
			
			reloj_reg <= reloj_next;
		
		end if;
		
	end process;
		
	--logica de estado siguiente
		
	reloj_next <= (others=>'0') when reloj_reg = 5000 else
						reloj_reg + 1;
							
		--logica de salida
	
	start <= '1' when reloj_reg >= 0 and reloj_reg < 8 else 
			  '0';
 
	--wr_uart <= '1' when reloj_reg = 4999  else
					--'0';
	
	end Behavioral;

