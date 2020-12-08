library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity Guest_ProgramMemory is
	port(
		clk			: in  STD_LOGIC;
		reset		: in  STD_LOGIC;
		cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
		cpu_wren	: in  STD_LOGIC;
		wrFlag		: in  STD_LOGIC;
		clrFlag		: out STD_LOGIC;
		guest_pc	: in  STD_LOGIC_VECTOR (9 downto 0);
		guest_insn	: out STD_LOGIC_VECTOR (11 downto 0)
	);
end Guest_ProgramMemory;
	
architecture Behavioral of Guest_ProgramMemory is

	signal		wrAddr		:	STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
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
	
	Memory: InsnRAM_12bit generic map(10) port map(
		clk			=> clk,
		reset		=> reset,
		-- --
		wrAddr		=> wrAddr,
		wrData		=> wrData,
		wren		=> wren,
		-- --
		rdAddr		=> guest_pc,
		rdData		=> guest_insn
	);		

end Behavioral;