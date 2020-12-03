library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.all;

entity IO_Module is
	generic(
		-- 0..7 inputs; 8..15 outputs
		readonly	:	STD_LOGIC_VECTOR (15 downto 0) := x"00FF"
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
end IO_Module;
	
architecture Behavioral of IO_Module is

	signal		io_regs		:	IO_ARRAY (0 to 15);

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			for i in 0 to 15 loop
				if (readonly(i) = '1') then
					io_regs(i) <= io_ports(i);
					io_ports(i) <= (others => 'Z');
				elsif (cpu_wren = '1') then
					io_regs(to_integer(unsigned(cpu_addr))) <= cpu_in;
				else
					io_ports(i) <= io_regs(i);
				end if;
			end loop;
			
			cpu_dout <= io_regs(to_integer(unsigned(cpu_addr)));
		end if;
	end process;

end Behavioral;