library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.all;

entity tb_IO_Module is
end tb_IO_Module;
	
architecture Behavioral of tb_IO_Module is

	component IO_Module is
		generic(
			-- 0..7 inputs; 8..15 outputs
			readonly	:	STD_LOGIC_VECTOR (0 to 15) := x"FF00"
		);
		port(
			clk			: in  STD_LOGIC;
			cpu_in		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_addr	: in  STD_LOGIC_VECTOR (3 downto 0);
			cpu_wren	: in  STD_LOGIC;
			cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
			-- --
			io_ports	: inout IO_ARRAY (0 to 15)
		);
	end component;
	
	signal	clk			:	STD_LOGIC := '0';
	signal	cpu_in		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal	cpu_addr	:	STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	signal	cpu_wren	:	STD_LOGIC := '0';
	signal	io_ports	:	IO_ARRAY (0 to 15) := (others => (others => '0'));

begin

	process
	begin
		wait for 5 ns;
		io_ports(0) <= x"55";
		wait for 10 ns;
		cpu_in <= x"AA";
		cpu_addr <= x"A";
		cpu_wren <= '1';
		wait for 10 ns;
		cpu_addr <= x"0";
		wait;
	end process;

	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	uut: IO_Module port map(
		clk			=> clk,
		cpu_in		=> cpu_in,
		cpu_addr	=> cpu_addr,
		cpu_wren	=> cpu_wren,
		cpu_dout	=> open,
		io_ports	=> io_ports
	);
	

end Behavioral;