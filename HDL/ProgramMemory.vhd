library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity ProgramMemory is
	port(
		clk			: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
		cpu_wren	: in  STD_LOGIC;
		wrFlag		: in  STD_LOGIC;
		clrFlag		: out STD_LOGIC;
		prog_addr	: in  STD_LOGIC_VECTOR (10 downto 0);
		instruction	: out STD_LOGIC_VECTOR (11 downto 0)
	);
end ProgramMemory;
	
architecture Behavioral of ProgramMemory is

	signal		wrAddr		:	STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
	signal		ramAddr		:	STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
	signal		wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		wren		:	STD_LOGIC := '0';

begin

	Control: MemoryController generic map(11) port map(
		clk			=> clk,
		input		=> cpu_din,
		cpu_wren	=> cpu_wren,
		cpu_rden	=> '0',
		wrFlag		=> wrFlag,
		-- --
		addrOut		=> wrAddr,
		dataOut		=> wrData,
		wrenOut		=> wren,
		clrFlag		=> clrFlag
	);
	
	ramAddr <= '1' & wrAddr;
	
	Memory: InsnRAM_12bit generic map(11) port map(
		clk			=> clk,
		reset		=> reset,
		-- --
		wrAddr		=> ramAddr,
		wrData		=> wrData,
		wren		=> wren,
		-- --
		rdAddr		=> prog_addr,
		rdData		=> instruction
	);		

end Behavioral;