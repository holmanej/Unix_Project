library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX is
	port(
		clk			: in  STD_LOGIC;
		RX			: in  STD_LOGIC;
		-- --
		output		: out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
		doneBit		: out STD_LOGIC
	);
end UART_RX;
	
architecture Behavioral of UART_RX is

	type stateType is (
		idle,
		start,
		readRX
	);
	
	signal		state	:	stateType := idle;
	
	signal		timer	:	UNSIGNED (7 downto 0) := (others => '0');
	signal		index	:	UNSIGNED (3 downto 0) := (others => '0');

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			timer <= timer + 1;
			
			case state is
				when idle =>
					if (RX = '0') then
						timer <= (others => '0');
						index <= (others => '0');
						doneBit <= '0';
						state <= start;
					else
						doneBit <= '1';
					end if;
					
				when start =>
					if (timer = 50) then
						timer <= (others => '0');
						state <= readRX;
					end if;
				
				when readRX =>
					if (index < 8) then
						if (timer = 100) then
							timer <= (others => '0');
							output(to_integer(index)) <= RX;
							index <= index + 1;
						end if;
					else
						state <= idle;
					end if;
			end case;
		end if;
	end process;						

end Behavioral;