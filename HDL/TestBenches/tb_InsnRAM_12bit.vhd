library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity tb_InsnRAM_12bit is
end tb_InsnRAM_12bit;
	
architecture Behavioral of tb_InsnRAM_12bit is
	
	signal	clk			:	STD_LOGIC := '0';
	signal	wrAddr		:	STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
	signal	wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal	wren		:	STD_LOGIC := '0';
	signal	rdAddr		:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

begin

	process
	begin
		wait for 5 ns;
		wrData <= x"55";
		wait for 10 ns;
		wren <= '1';
		wait for 10 ns;
		wrAddr <= "00000000001";
		wrData <= x"12";
		wait for 10 ns;
		wren <= '0';
		rdAddr <= "0000000001";
		
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: InsnRAM_12bit generic map(10) port map(
		clk			=> clk,
		reset		=> '0',
		-- --
		wrAddr		=> wrAddr,
		wrData		=> wrData,
		wren		=> wren,
		-- --
		rdAddr		=> rdAddr,
		rdData		=> open
	);

end Behavioral;