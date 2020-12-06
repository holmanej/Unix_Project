library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.ALL;

entity tb_Unix_Project is
end tb_Unix_Project;
	
architecture Behavioral of tb_Unix_Project is

	constant	sixnine	:	STD_LOGIC_VECTOR (7 downto 0) := x"69";
	
	signal	clk			:	STD_LOGIC := '0';
	signal	switches	:	STD_LOGIC_VECTOR (7 downto 0) := x"55";
	signal	rx			:	STD_LOGIC := '1';

begin

	process
	begin
		wait for 5 ns;
		rx <= '0';
		wait for 10 us;
		for i in 0 to 7 loop
			rx <= sixnine(i);
			wait for 10 us;
		end loop;
		rx <= '1';
		
		wait;
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