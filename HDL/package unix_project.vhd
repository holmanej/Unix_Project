library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
----------------------------------------------------------------------------
package unix_project is

	-- CONSTANTS --
	constant	NOP		:	STD_LOGIC_VECTOR (11 downto 0) := x"402";
	
	-- TYPES --
	type	BIT8_ARRAY	is	ARRAY (integer range<>) of STD_LOGIC_VECTOR (7 downto 0);
	type	BIT12_ARRAY	is	ARRAY (0 to 2047) of STD_LOGIC_VECTOR (11 downto 0);

	-- SUBMODULES --
	component MemoryController is
		generic(
			M			:	INTEGER := 8
		);
		port(
			clk			: in  STD_LOGIC;
			input		: in  STD_LOGIC_VECTOR (7 downto 0);
			wrFlag		: in  STD_LOGIC;
			cpu_wren	: in  STD_LOGIC;
			cpu_rden	: in  STD_LOGIC;
			-- --
			addrOut		: out STD_LOGIC_VECTOR (M-1 downto 0);
			dataOut		: out STD_LOGIC_VECTOR (7 downto 0);
			wrenOut		: out STD_LOGIC := '0';
			clrFlag		: out STD_LOGIC := '0'
		);
	end component;
	
	component SPRAM_MxN is
		generic(
			M		:	INTEGER := 8;	-- depth
			N		:	INTEGER := 16	-- width
		);
		port(
			clk		: in  STD_LOGIC;
			reset	: in  STD_LOGIC := '0';
			-- --
			wrAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
			wrData	: in  STD_LOGIC_VECTOR (N-1 downto 0);
			wren	: in  STD_LOGIC;
			-- --
			rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
			rdData	: out STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
	component InsnRAM_12bit is
		generic(
			M		:	INTEGER := 10
		);
		port(
			clk		: in  STD_LOGIC;
			reset	: in  STD_LOGIC := '0';
			-- --
			wrAddr	: in  STD_LOGIC_VECTOR (M downto 0) := (others => '0');
			wrData	: in  STD_LOGIC_VECTOR (7 downto 0);
			wren	: in  STD_LOGIC;
			-- --
			rdAddr	: in  STD_LOGIC_VECTOR (M-1 downto 0);
			rdData	: out STD_LOGIC_VECTOR (11 downto 0)
		);
	end component;
	
	-- Top Modules
	component SRISC_CPU is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			instruction	: in  STD_LOGIC_VECTOR (11 downto 0);
			prog_addr	: out STD_LOGIC_VECTOR (10 downto 0);
			io_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			io_dout		: out STD_LOGIC_VECTOR (7 downto 0);
			io_addr		: out STD_LOGIC_VECTOR (3 downto 0);
			io_wren		: out STD_LOGIC;
			io_rden		: out STD_LOGIC
		);
	end component;
	
	component IO_Module is
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
			inputs			: in  BIT8_ARRAY (0 to 15) := (others => (others => '0'));
			outputs			: out BIT8_ARRAY (0 to 15) := (others => (others => '0'))
		);
	end component;
	
	component ProgramMemory is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_wren	: in  STD_LOGIC;
			wrFlag		: in  STD_LOGIC;
			clrFlag		: out STD_LOGIC;
			prog_addr	: in  STD_LOGIC_VECTOR (10 downto 0);
			instruction	: out STD_LOGIC_VECTOR (11 downto 0)
		);
	end component;
	
	component GP_RAM is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			cpu_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			cpu_wren	: in  STD_LOGIC;
			cpu_rden	: in  STD_LOGIC;
			cpu_dout	: out STD_LOGIC_VECTOR (7 downto 0);
			wrFlag		: in  STD_LOGIC;
			clrFlag		: out STD_LOGIC
		);
	end component;
	
	-- ENTITY --
	component Unix_Computer is
		port(
			clk			: in  STD_LOGIC;
			-- --
			switches	: in  STD_LOGIC_VECTOR (7 downto 0);
			rx			: in  STD_LOGIC;
			-- --
			leds		: out STD_LOGIC_VECTOR (7 downto 0);
			tx			: out STD_LOGIC
		);
	end component;
	
	-- FUNCTIONS --
	impure function READ_ROM_FILE(the_file_name: in string) return BIT12_ARRAY;
	impure function READ_GUEST_FILE(the_file_name: in string) return BIT8_ARRAY;
	
end unix_project;

package body unix_project is

	-- FUNCTIONS --	
	impure function READ_ROM_FILE(the_file_name: in string) return BIT12_ARRAY is		
		file     in_file:    text open read_mode is the_file_name;
		variable ram_data:   BIT12_ARRAY;
		variable input_line: line;
	begin
		for i in 0 to 2047 loop
			if not endfile(in_file) then
				readline(in_file, input_line);
				read(input_line, ram_data(i));
			else
				ram_data(i) := NOP;
			end if;
		end loop;
		
		file_close(in_file);
		return ram_data;
	end function;
	
	impure function READ_GUEST_FILE(the_file_name: in string) return BIT8_ARRAY is		
		file     in_file:    text open read_mode is the_file_name;
		variable ram_data:   BIT8_ARRAY (0 to 2047);
		variable input_line: line;
	begin
		for i in 0 to 2047 loop
			if not endfile(in_file) then
				readline(in_file, input_line);
				read(input_line, ram_data(i));
			else
				ram_data(i) := x"00";
			end if;
		end loop;
		
		file_close(in_file);
		return ram_data;
	end function;
	
end unix_project;