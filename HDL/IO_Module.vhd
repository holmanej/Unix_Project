library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.all;

entity IO_Module is
	port(
		clk				: in  STD_LOGIC;
		cpu_din			: in  STD_LOGIC_VECTOR (7 downto 0);
		cpu_addr		: in  STD_LOGIC_VECTOR (3 downto 0);
		cpu_wren		: in  STD_LOGIC;
		cpu_rden		: in  STD_LOGIC;
		cpu_dout		: out STD_LOGIC_VECTOR (7 downto 0);
		-- --
		input_sets		: in  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		output_resets	: in  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		input_flags		: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		output_flags	: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		inputs			: in  IO_ARRAY (0 to 15) := (others => (others => '0'));
		outputs			: out IO_ARRAY (0 to 15) := (others => (others => '0'))
	);
end IO_Module;
	
architecture Behavioral of IO_Module is

begin

	process(clk)
	begin		
		if (rising_edge(clk)) then
			-- cpu writes to output and sets flag
			if (cpu_wren = '1') then
				outputs(to_integer(unsigned(cpu_addr))) <= cpu_din;
				output_flags(to_integer(unsigned(cpu_addr))) <= '1';
			-- device reads output and resets flag
			else
				for i in 0 to 15 loop
					if (output_resets(i) = '1') then
						output_flags(i) <= '0';
					end if;
				end loop;
			end if;
			
			-- device writes input and sets flag
			for i in 0 to 15 loop
				if (input_sets(i) = '1') then
					input_flags(i) <= '1';
				end if;
			end loop;
			-- cpu reads input and resets flag
			if (cpu_rden = '1') then
				input_flags(to_integer(unsigned(cpu_addr))) <= '0';
			end if;
		end if;
	end process;	
	
	cpu_dout <= inputs(to_integer(unsigned(cpu_addr)));

end Behavioral;