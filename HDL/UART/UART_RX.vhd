library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX is
	generic(
		baud_delay	:	INTEGER := 100
	);
	port(
		clk			: in  STD_LOGIC;
		RX			: in  STD_LOGIC;
		-- --
		output		: out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
		wrFlag		: out STD_LOGIC
	);
end UART_RX;
	
architecture Behavioral of UART_RX is

	type stateType is (
		idle,
		start,
		readRX,
		stop
	);
	
	signal		state	:	stateType := idle;
	
	signal		timer	:	UNSIGNED (9 downto 0) := (others => '0');
	signal		elapsed	:	STD_LOGIC := '0';
	signal		index	:	UNSIGNED (3 downto 0) := (others => '0');

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (state = idle) then
				timer <= (others => '0');
			elsif (state = start and timer = baud_delay / 2) then
				elapsed <= '1';
				timer <= (others => '0');
			elsif (timer = baud_delay) then
				elapsed <= '1';
				timer <= (others => '0');
			else
				elapsed <= '0';
				timer <= timer + 1;
			end if;
			
			case state is
				when idle =>
					wrFlag <= '0';
					if (RX = '0') then
						index <= (others => '0');						
						state <= start;
					end if;
					
				when start =>
					if (elapsed = '1') then
						state <= readRX;
					end if;
				
				when readRX =>
					if (index < 8) then
						if (elapsed = '1') then
							output(to_integer(index)) <= RX;
							index <= index + 1;
						end if;
					else
						state <= stop;
					end if;
					
				when stop =>
					if (elapsed = '1') then
						wrFlag <= '1';
						state <= idle;
					end if;
					
			end case;
		end if;
	end process;						

end Behavioral;