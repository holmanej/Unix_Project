library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity tb_MemoryController is
end tb_MemoryController;
	
architecture Behavioral of tb_MemoryController is
	
	signal	clk			:	STD_LOGIC := '0';
	signal	input		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal	cpu_wren	:	STD_LOGIC := '0';

begin

	process
	begin
		wait for 5 ns;
		input <= x"05";
		wait for 10 ns;
		input <= x"01";
		wait for 10 ns;
		input <= x"02";
		wait for 10 ns;
		input <= x"55";
		cpu_wren <= '1';
		
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: MemoryController generic map(512) port map(
		clk			=> clk,
		input		=> input,
		cpu_wren	=> cpu_wren,
		-- --
		addrOut		=> open,
		dataOut		=> open,
		wrenOut		=> open
	);

end Behavioral;