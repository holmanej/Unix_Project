library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.ALL;

entity tb_Unix_Project is
end tb_Unix_Project;
	
architecture Behavioral of tb_Unix_Project is

	constant	sixnine	:	STD_LOGIC_VECTOR (7 downto 0) := x"69";
	constant	ff		:	STD_LOGIC_VECTOR (7 downto 0) := x"ff";
	constant	zero	:	STD_LOGIC_VECTOR (7 downto 0) := x"00";
	constant	eighto	:	STD_LOGIC_VECTOR (7 downto 0) := x"80";
	
	constant	helloW	:	BIT8_ARRAY (0 to 2047) := (
		"01001000",
		"00000000",
		"10000001",
		"00001000",
		"01100101",
		"00000000",
		"10000010",
		"00001000",
		"01101100",
		"00000000",
		"10000011",
		"00001000",
		"10000100",
		"00001000",
		"01101111",
		"00000000",
		"10000101",
		"00001000",
		"00101100",
		"00000000",
		"10000110",
		"00001000",
		"00100000",
		"00000000",
		"10000111",
		"00001000",
		"01010111",
		"00000000",
		"10001000",
		"00001000",
		"01101111",
		"00000000",
		"10001001",
		"00001000",
		"01110010",
		"00000000",
		"10001010",
		"00001000",
		"01101100",
		"00000000",
		"10001011",
		"00001000",
		"01100100",
		"00000000",
		"10001100",
		"00001000",
		"00100001",
		"00000000",
		"10001101",
		"00001000",
		"00001010",
		"00000000",
		"10001110",
		"00001000",
		"00001101",
		"00000000",
		"10001111",
		"00001000",
		"00000000",
		"00000000",
		"01110010",
		"00001011",
		"00000100",
		"00000001",
		"11010010",
		"00000111",
		"11001110",
		"00000100",
		"00011110",
		"00001100",
		"00001010",
		"00000100",
		"00000000",
		"00001001",
		"11110010",
		"00001001",
		"00001000",
		"00000100",
		"00001111",
		"00000100",
		"00011110",
		"00001100",
		"11111111",
		others => (others => '0')
	);

	
	signal	clk			:	STD_LOGIC := '0';
	signal	switches	:	STD_LOGIC_VECTOR (7 downto 0) := x"55";
	signal	rx			:	STD_LOGIC := '1';

begin

	process
	begin
		wait for 5 ns;
		
		for i in 0 to 2047 loop
			rx <= '0';
			wait for 1 us;
			for j in 0 to 7 loop
				rx <= helloW(i)(j);
				wait for 1 us;
			end loop;
			rx <= '1';
			wait for 1 us;
		end loop;
		
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: Unix_Computer port map(
		clk			=> clk,
		switches	=> switches,
		rx			=> rx,
		leds		=> open,
		tx			=> open
	);

end Behavioral;