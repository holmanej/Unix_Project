library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_TX is
	port(
		clk			: in  STD_LOGIC;
		input		: in  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
		rdFlag		: in  STD_LOGIC;
		-- --
		clrFlag		: out STD_LOGIC := '0';
		doneBit		: out STD_LOGIC := '0';
		TX			: out STD_LOGIC := '1'
	);
end UART_TX;
	
architecture Behavioral of UART_TX is

	type stateType is (
		idle,
		start,
		setTX,
		stop
	);
	
	signal		state	:	stateType := idle;
	
	signal		timer	:	UNSIGNED (9 downto 0) := (others => '0');
	signal		elapsed	:	STD_LOGIC := '0';
	
	signal		index	:	UNSIGNED (3 downto 0) := (others => '0');
	signal		newChar	:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (timer < 1000) then
				timer <= timer + 1;
				elapsed <= '0';
			else
				timer <= (others => '0');
				elapsed <= '1';
			end if;
		
			case state is
				when idle =>
					if (rdFlag = '1') then
						doneBit <= '0';
						clrFlag <= '1';
						newChar <= input;
						TX <= '0';
						state <= start;
					else
						doneBit <= '1';
						TX <= '1';						
					end if;
					
				when start =>
					if (elapsed = '1') then
						clrFlag <= '0';	
						state <= setTX;
					end if;
					
				when setTX =>
					if (index < 8) then
						if (elapsed = '1') then
							index <= index + 1;
						else
							TX <= newChar(to_integer(index));
						end if;
					else
						TX <= '1';
						state <= stop;
					end if;
					
				when stop =>
					if (elapsed = '1') then						
						index <= (others => '0');
						state <= idle;
					end if;					
			end case;
		end if;
	end process;			

end Behavioral;