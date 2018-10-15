----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:50:53 10/04/2018 
-- Design Name: 
-- Module Name:    Top_microfono - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.Filtro_pckg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_microfono is
	
	generic (N: natural :=20;
				N_idx : natural :=5
	);
		
	port(
		
		clk, reset: in std_logic;
		chip_select:out std_logic;
		serial_data:in std_logic;
		sclk: out std_logic;
      tx, tx_full: out std_logic
		
	);

end Top_microfono;

architecture Behavioral of Top_microfono is

		signal filter : cte_t(0 to N):=
			("000000000000000000000000",
			"000000001011111111110011",                                                       
			"000000011001111110100111",                                                      
			"000000001111011111101101",			
			"111111001101010000100110",                                                       
			"111101110011011001100000",                                                       
			"111101111101100000001000",                                                       
			"000001101100101011000000",                                                       
			"001000110100101100000000",                                                       
			"010000000101100001010010",                                                       
			"010011001010111110110001",                                                       
			"010000000101100001010010",                                                       
			"001000110100101100000000",                                                       
			"000001101100101011000000",                                                       
			"111101111101100000001000",                                                       
			"111101110011011001100000",                                                       
			"111111001101010000100110",                                                       
			"000000001111011111101101",                                                       
			"000000011001111110100111",                                                       
			"000000001011111111110011",                                            
			"000000000000000000000000");  
				
		signal data_new: x_t(0 to N); 
		signal data : std_logic_vector(11 downto 0);
		signal data_filter : std_logic_vector(7 downto 0);
		signal start, done_mic, done_piola, done_shift: std_logic;
		signal done_filter: std_logic;

begin

	contador: entity work.Contador_20k(Behavioral)  --envia una senal de start con una frecuencia de 20 kHz
	port map(CLK=>clk, RESET=>reset, start => start);
	
	microfono: entity work.PmodMicrefcomp(PmodMic) 
	port map(CLK=>clk, RST=>reset, SDATA=>serial_data ,SCLK=>sclk, nCS=>chip_select, DATA=>data, START=>start , DONE=>done_mic);		
	
	maquinola: entity work.Maquinola (Behavioral)
	port map(clk => clk, reset => reset, start => done_mic, done=> done_piola);
	
	colaFIFO: entity work.Shift_reg(Behavioral)
	port map(clk => clk, reset => reset, start => done_piola, data => data(11 downto 4), data_new => data_new, done => done_shift);
	
	filtro: entity work.filter(Behavioral)
	port map(clk=>clk, reset => reset, start => done_shift, cte => filter, a => data_new, result => data_filter, done=>done_filter);
	
	transmisor: entity work.uart_tx_unit(Behavioral)
	port map(clk=>clk, reset=>reset, tx=>tx, tx_full=>tx_full, w_data=>data_filter, wr_uart=>done_filter);
	
end Behavioral;

