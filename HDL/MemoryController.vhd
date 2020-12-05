library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryController is
	generic(
		M			:	INTEGER := 512
	);
	port(
		clk			: in  STD_LOGIC;
		input		: in  STD_LOGIC_VECTOR (7 downto 0);
		cpu_wren	: in  STD_LOGIC;
		-- --
		addrOut		: out STD_LOGIC_VECTOR (M-1 downto 0);
		dataOut		: out STD_LOGIC_VECTOR (7 downto 0);
		wrenOut		: out STD_LOGIC
	);
end MemoryController;
	
architecture Behavioral of MemoryController is

	type stateType is (
		command,
		addrL,
		addrH,
		data
	);
	
	signal		state		:	stateType := command;
	
	signal		rw_sel		:	STD_LOGIC := '0';
	signal		burst_len	:	UNSIGNED (6 downto 0) := (others => '0');
	signal		addr_int	:	UNSIGNED (M-1 downto 0) := (others => '0');

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (state = command) then
				wrenOut <= '0';
				
				if (input(7 downto 1) /= "0000000") then
					rw_sel <= input(0);
					burst_len <= unsigned(input(7 downto 1));
					state <= addrL;
				end if;
			elsif (state = addrL) then
				addr_int(7 downto 0) <= unsigned(input);
				state <= addrH;
			elsif (state = addrH) then
				addr_int(M-1 downto 8) <= unsigned(input(M-9 downto 0));
				state <= data;
			else
				if (burst_len > 0) then
					dataOut <= input;
					wrenOut <= rw_sel;
					if (cpu_wren = '1') then
						addrOut <= std_logic_vector(addr_int + 1);
						burst_len <= burst_len - 1;
					end if;
				else
					state <= command;
				end if;
			end if;
		end if;
	end process;
	
	addrOut <= std_logic_vector(addr_int);

end Behavioral;