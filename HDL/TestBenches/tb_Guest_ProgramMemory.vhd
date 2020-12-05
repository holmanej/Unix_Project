library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.unix_project.all;

entity tb_Guest_ProgramMemory is
end tb_Guest_ProgramMemory;
	
architecture Behavioral of tb_Guest_ProgramMemory is
	
	signal	clk			:	STD_LOGIC := '0';
	signal	cpu_din		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal	cpu_wren	:	STD_LOGIC := '0';
	signal	guest_pc	:	STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

begin

	process
	begin
		wait for 5 ns;
		cpu_din <= x"84";
		wait for 10 ns;
		cpu_din <= x"01";
		wait for 10 ns;
		cpu_din <= x"01";
		wait for 10 ns;
		cpu_din <= x"55";
		cpu_wren <= '1';
		wait for 10 ns;
		cpu_din <= x"56";
		wait for 10 ns;
		cpu_din <= x"57";
		wait for 10 ns;
		cpu_din <= x"58";
		wait for 10 ns;
		cpu_din <= x"59";
		wait for 10 ns;
		guest_pc <= "0010000010";
		
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: Guest_ProgramMemory port map(
		clk			=> clk,
		reset		=> '0',
		cpu_din		=> cpu_din,
		cpu_wren	=> cpu_wren,
		guest_pc	=> guest_pc,
		guest_insn	=> open
	);

end Behavioral;