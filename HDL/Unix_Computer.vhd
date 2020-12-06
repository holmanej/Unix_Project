library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.srisc.all;
use work.unix_project.ALL;
use work.uart.all;

entity Unix_Computer is
	port(
		clk			: in  STD_LOGIC;
		-- --
		switches	: in  STD_LOGIC_VECTOR (7 downto 0);
		rx			: in  STD_LOGIC;
		-- --
		leds		: out STD_LOGIC_VECTOR (7 downto 0);
		tx			: out STD_LOGIC
	);
end Unix_Computer;
	
architecture Behavioral of Unix_Computer is

	-- IO --	
	signal		io_wrData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		io_rdData		:	STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal		io_rwAddr		:	STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	signal		io_wren			:	STD_LOGIC := '0';
	signal		io_rden			:	STD_LOGIC := '0';
	
	signal		iFlag_sets		:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal		oFlag_resets	:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		alias	tx_clr			is	oFlag_resets(2);
	signal		iFlags			:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal		oFlags			:	STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		alias	tx_flag			is	oFlags(2);
	signal		io_inputs		:	IO_ARRAY (0 to 15);
		alias	sw_in			is	io_inputs(0);
		alias	rx_output		is	io_inputs(1);
		alias	uart_status		is	io_inputs(2);
	signal		io_outputs		:	IO_ARRAY (0 to 15);		
		alias	led_out			is	io_outputs(0);
		alias	tx_input		is	io_outputs(2);
	
	-- UART --
	signal		tx_done			:	STD_LOGIC;
	signal		rx_done			:	STD_LOGIC;

begin

	sw_in <= switches;
	leds <= led_out;
	
	uart_status <= (2 => tx_done, 1 => rx_done, others => '0');

	CPU: SRISC_CPU port map (
		clk			=> clk,
		reset		=> '0',
		guest_insn	=> x"000",
		guest_pc	=> open,
		io_din		=> io_rdData,
		io_dout		=> io_wrData,
		io_addr		=> io_rwAddr,
		io_wren		=> io_wren,
		io_rden		=> io_rden
	);
	
	IO: IO_Module port map(
		clk				=> clk,
		cpu_din			=> io_wrData,
		cpu_addr		=> io_rwAddr,
		cpu_wren		=> io_wren,
		cpu_rden		=> io_rden,
		cpu_dout		=> io_rdData,
		-- --
		input_sets		=> iFlag_sets,
		output_resets	=> oFlag_resets,
		input_flags		=> iFlags,
		output_flags	=> oFlags,
		inputs			=> io_inputs,
		outputs			=> io_outputs
	);
	
	uartTX: UART_TX port map(
		clk			=> clk,
		input		=> tx_input,
		rdFlag		=> tx_flag,
		-- --
		clrFlag		=> tx_clr,
		doneBit		=> tx_done,
		TX			=> tx
	);
	
	uartRX: UART_RX port map(
		clk			=> clk,
		RX			=> rx,
		-- --
		output		=> rx_output,
		doneBit		=> rx_done
	);

end Behavioral;