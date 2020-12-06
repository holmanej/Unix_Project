library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.ALL;

entity tb_Unix_Project is
end tb_Unix_Project;
	
architecture Behavioral of tb_Unix_Project is
	
	signal	clk			:	STD_LOGIC := '0';
	signal	switches	:	STD_LOGIC_VECTOR (7 downto 0) := x"55";

begin

	process
	begin
		wait for 5 ns;
		switches <= x"55";
		wait for 10 ns;
		switches <= x"69";
		
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
		leds		=> open
	);

end Behavioral;