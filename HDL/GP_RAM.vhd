library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity GP_RAM is
	port(
		clk			: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
		cpu_wren	: in  STD_LOGIC;
		cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0)
	);
end GP_RAM;
	
architecture Behavioral of GP_RAM is

	signal		rwAddr		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal		wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		wren		:	STD_LOGIC := '0';

begin

	Control: MemoryController generic map(10) port map(
		clk			=> clk,
		input		=> cpu_din,
		cpu_wren	=> cpu_wren,
		-- --
		addrOut		=> rwAddr,
		dataOut		=> wrData,
		wrenOut		=> wren
	);
	
	Memory: SPRAM_MxN generic map(10, 8) port map(
		clk			=> clk,
		reset		=> reset,
		-- --
		wrAddr		=> rwAddr,
		wrData		=> wrData,
		wren		=> wren,
		-- --
		rdAddr		=> rwAddr,
		rdData		=> cpu_dout
	);		

end Behavioral;