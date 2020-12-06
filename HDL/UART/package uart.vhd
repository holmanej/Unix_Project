library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
----------------------------------------------------------------------------
package uart is

	-- MODULES --
	component UART_TX is
		port(
			clk			: in  STD_LOGIC;
			input		: in  STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
			rdFlag		: in  STD_LOGIC;
			-- --
			clrFlag		: out STD_LOGIC := '0';
			doneBit		: out STD_LOGIC := '0';
			TX			: out STD_LOGIC := '1'
		);
	end component;
	
	component UART_RX is
		port(
			clk			: in  STD_LOGIC;
			RX			: in  STD_LOGIC;
			-- --
			output		: out STD_LOGIC_VECTOR (7 downto 0);
			doneBit		: out STD_LOGIC
		);
	end component;
	
end uart;