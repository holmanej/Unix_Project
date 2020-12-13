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
		cpu_rden	: in  STD_LOGIC;
		cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
		wrFlag		: in  STD_LOGIC;
		clrFlag		: out STD_LOGIC
	);
end GP_RAM;
	
architecture Behavioral of GP_RAM is

	signal		rwAddr		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal		wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		wren		:	STD_LOGIC := '0';
	
	signal		mem_int		:	BIT8_ARRAY (0 to 1023) := READ_GUEST_FILE("C:\Users\holma\source\repos\Unix_Project\S_Code\S_ROM.bin", 1024);

begin

	Control: MemoryController generic map(10) port map(
		clk			=> clk,
		input		=> cpu_din,
		cpu_wren	=> cpu_wren,
		cpu_rden	=> cpu_rden,
		wrFlag		=> wrFlag,
		-- --
		addrOut		=> rwAddr,
		dataOut		=> wrData,
		wrenOut		=> wren,
		clrFlag		=> clrFlag
	);

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (wren = '1') then
				mem_int(to_integer(unsigned(rwAddr))) <= wrData;
			end if;
			
			cpu_dout <= mem_int(to_integer(unsigned(rwAddr)));
		end if;
	end process;

end Behavioral;