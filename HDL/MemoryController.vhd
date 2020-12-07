library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryController is
	generic(
		M			:	INTEGER := 10
	);
	port(
		clk			: in  STD_LOGIC;
		input		: in  STD_LOGIC_VECTOR (7 downto 0);
		wrFlag		: in  STD_LOGIC;
		cpu_wren	: in  STD_LOGIC;
		cpu_rden	: in  STD_LOGIC;
		-- --
		addrOut		: out STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
		dataOut		: out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
		wrenOut		: out STD_LOGIC := '0';
		clrFlag		: out STD_LOGIC := '0'
	);
end MemoryController;
	
architecture Behavioral of MemoryController is

	type stateType is (
		command,
		addrL,
		addrH,
		data,
		inc,
		stop
	);
	
	signal		state		:	stateType := command;
	
	signal		rw_sel		:	STD_LOGIC := '0';
	signal		burst_len	:	UNSIGNED (6 downto 0) := (others => '0');
	signal		addr_int	:	UNSIGNED (M-1 downto 0) := (others => '0');

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			case state is
				when command =>
					if (wrFlag = '1') then
						rw_sel <= input(7);
						burst_len <= unsigned(input(6 downto 0));
						state <= addrL;
					end if;
					
				when addrL =>
					addr_int(7 downto 0) <= unsigned(input);
					state <= addrH;
					
				when addrH =>
					addr_int(M-1 downto 8) <= unsigned(input(M-9 downto 0));
					state <= data;
					
				when data =>					
					if (cpu_wren = '1' or cpu_rden = '1') then
						wrenOut <= rw_sel;						
						if (burst_len > 1) then
							state <= inc;
						else
							clrFlag <= '1';
							state <= stop;
						end if;
					end if;
					
				when inc =>
					wrenOut <= '0';					
					addr_int <= addr_int + 1;
					burst_len <= burst_len - 1;
					state <= data;
					
				when stop =>
					wrenOut <= '0';	
					clrFlag <= '0';
					state <= command;
				
				when others =>
					wrenOut <= '0';
					state <= stop;
					
			end case;
		end if;
	end process;
	
	addrOut <= std_logic_vector(addr_int);
	dataOut <= input;

end Behavioral;