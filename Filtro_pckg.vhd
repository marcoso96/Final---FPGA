--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package Filtro_pckg is 

	constant Bits_cte_t : integer :=24;
	constant Bits_x_t: integer :=8;
	
	type x_t is array(integer range <>) of std_logic_vector(Bits_x_t-1 downto 0);
	type cte_t is array(integer range <>) of std_logic_vector(Bits_cte_t-1 downto 0);

end Filtro_pckg;
