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
	
	constant	helloW	:	BIT8_ARRAY (0 to 2047) := READ_GUEST_FILE("C:\Users\holma\source\repos\Unix_Project\S_Code\hello_world.bin", 2048);
	constant	lmao	:	BIT8_ARRAY (0 to 6) := (
		x"4C",
		x"6D",
		x"66",
		x"08",
		x"61",
		x"6F",
		x"0D"
	);
	
	signal	clk			:	STD_LOGIC := '0';
	signal	switches	:	STD_LOGIC_VECTOR (7 downto 0) := x"55";
	signal	rx			:	STD_LOGIC := '1';

begin

	process
	begin
		wait for 5 ns;
		
		for i in 0 to 6 loop
			rx <= '0';
			wait for 1 us;
			for j in 0 to 7 loop
				rx <= lmao(i)(j);
				wait for 1 us;
			end loop;
			rx <= '1';
			wait for 1 us;
		end loop;
		
		wait for 300 us;
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