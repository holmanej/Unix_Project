library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryController is
	generic(
		M			:	INTEGER := 8
	);
	port(
		clk			: in  STD_LOGIC;
		input		: in  STD_LOGIC_VECTOR (7 downto 0);
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

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (state = command) then
				wrenOut <= '0';
				
				if (input /= (others => '0') then
					rw_sel <= input(0);
					burst_len <= input(7 downto 1);
					state <= addrL;
				end if;
			elsif (state = addrL) then
				addrOut(7 downto 0) <= input;
				state <= addrH;
			elsif (state = addrH) then
				addrOut(M-1 downto 8) <= input(M-9 downto 0);
				state <= data;
			else
				if (burst_len > 0) then
					dataOut <= input;
					wrenOut <= rw_sel;
					burst_len <= burst_len - 1;
				else
					state <= command;
				end if;
			end if;
		end if;
	end process;

end Behavioral;