library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
library work;
----------------------------------------------------------------------------
package srisc is

	-- CONSTANTS --
	constant	NOP		:	STD_LOGIC_VECTOR (11 downto 0) := x"402";

	-- TYPES --
	type	IO_ARRAY	is	ARRAY (integer range<>) of STD_LOGIC_VECTOR (7 downto 0);
	type	INST_TYPE	is	ARRAY (0 to 1023) of STD_LOGIC_VECTOR (11 downto 0);
	type	MEM_TYPE	is	ARRAY (0 to 127) of STD_LOGIC_VECTOR (7 downto 0);
	
	-- 	COMPONENTS --
	component Mux_2to1_nbit is
		generic(
			w		: INTEGER := 8
		);
		port(
			a_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			b_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			sel		: in  STD_LOGIC;
			-- --
			output	: out STD_LOGIC_VECTOR (w-1 downto 0)
		);
	end component;
	
	component Mux_4to1_nbit is
		generic(
			w		: INTEGER := 8
		);
		port(
			in_1	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			in_2	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			in_3	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			in_4	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			sel		: in  STD_LOGIC_VECTOR (1 downto 0);
			-- --
			output	: out STD_LOGIC_VECTOR (w-1 downto 0)
		);
	end component;
	
	component SR_Latch is
		port(
			clk		: in  STD_LOGIC;
			set		: in  STD_LOGIC;
			reset	: in  STD_LOGIC;
			output	: out STD_LOGIC
		);
	end component;
	
	component Register_nbit is
		generic(
			w		: INTEGER := 4
		);
		port(
			clk		: in  STD_LOGIC;
			rst		: in  STD_LOGIC;
			wrData	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			wren	: in  STD_LOGIC;
			rdData	: out STD_LOGIC_VECTOR (w-1 downto 0) := (others => '0')
		);
	end component;
	
	component UnsignedAdder_nbit is
		generic(
			w		: INTEGER := 4
		);
		port(
			a_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			b_in	: in  STD_LOGIC_VECTOR (w-1 downto 0);
			output	: out STD_LOGIC_VECTOR (w-1 downto 0)
		);
	end component;

	-- Memory --
	component RegisterMemory is
		port(
			clk		: in  STD_LOGIC;
			wrAddr	: in  STD_LOGIC_VECTOR (1 downto 0);
			wrData	: in  STD_LOGIC_VECTOR (7 downto 0);
			wren	: in  STD_LOGIC;
			rdAddr_a: in  STD_LOGIC_VECTOR (1 downto 0);
			rdAddr_b: in  STD_LOGIC_VECTOR (1 downto 0);
			-- --
			rdData_a: out STD_LOGIC_VECTOR (7 downto 0);
			rdData_b: out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;

	-- Logic --
	component ProgramDecoder is
		port(
			inst_in		: in  STD_LOGIC_VECTOR (11 downto 0);
			cmp_in		: in  STD_LOGIC;
			src_sel		: in  STD_LOGIC;
			-- --
			prog_sel	: out STD_LOGIC;
			cmp_wren	: out STD_LOGIC;
			data_sel	: out STD_LOGIC_VECTOR (1 downto 0);
			reg_addr_sel: out STD_LOGIC;
			reg_wren	: out STD_LOGIC;
			mem_addr_sel: out STD_LOGIC;
			mem_wren	: out STD_LOGIC;
			ind_wren	: out STD_LOGIC;
			io_wren		: out STD_LOGIC;
			io_rden		: out STD_LOGIC;
			exec_cmd	: out STD_LOGIC;
			exit_cmd	: out STD_LOGIC
		);
	end component;
	
	component ALULogic is
		port(
			a_in	: in  STD_LOGIC_VECTOR (7 downto 0);
			b_in	: in  STD_LOGIC_VECTOR (7 downto 0);
			sel		: in  STD_LOGIC_VECTOR (3 downto 0);
			-- --
			output	: out STD_LOGIC_VECTOR (7 downto 0);
			cmp_out	: out STD_LOGIC
		);
	end component;
	
	-- Modules --
	component ProgramModule is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			cmp_in		: in  STD_LOGIC;
			instruction	: in  STD_LOGIC_VECTOR (11 downto 0);
			-- --
			prog_addr	: out STD_LOGIC_VECTOR (9 downto 0);
			inst_out	: out STD_LOGIC_VECTOR (9 downto 0);
			cmp_wren	: out STD_LOGIC;
			data_sel	: out STD_LOGIC_VECTOR (1 downto 0);
			reg_addr_sel: out STD_LOGIC;
			reg_wren	: out STD_LOGIC;
			mem_addr_sel: out STD_LOGIC;
			mem_wren	: out STD_LOGIC;
			ind_wren	: out STD_LOGIC;
			io_wren		: out STD_LOGIC;
			io_rden		: out STD_LOGIC
		);
	end component;
	
	component ALUModule is
		port(
			clk			: in  STD_LOGIC;
			alu_sel		: in  STD_LOGIC_VECTOR (3 downto 0);
			regData_a	: in  STD_LOGIC_VECTOR (7 downto 0);
			regData_b	: in  STD_LOGIC_VECTOR (7 downto 0);
			cmp_wren	: in  STD_LOGIC;
			-- --
			alu_out		: out STD_LOGIC_VECTOR (7 downto 0);
			cmp_out		: out STD_LOGIC
		);
	end component;
	
	component RegisterModule is
		port(
			clk			: in  STD_LOGIC;
			inst_in		: in  STD_LOGIC_VECTOR (9 downto 0);
			alu_data	: in  STD_LOGIC_VECTOR (7 downto 0);
			mem_data	: in  STD_LOGIC_VECTOR (7 downto 0);
			io_data		: in  STD_LOGIC_VECTOR (7 downto 0);
			data_sel	: in  STD_LOGIC_VECTOR (1 downto 0);
			addr_sel	: in  STD_LOGIC;
			wren		: in  STD_LOGIC;
			-- --
			regData_a	: out STD_LOGIC_VECTOR (7 downto 0);
			regData_b	: out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;
	
	component MemoryModule is
		port(
			clk			: in  STD_LOGIC;
			wrAddr		: in  STD_LOGIC_VECTOR (6 downto 0);
			wrData		: in  STD_LOGIC_VECTOR (7 downto 0);
			wren		: in  STD_LOGIC;
			rdAddr		: in  STD_LOGIC_VECTOR (6 downto 0);
			-- --
			rdData		: out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;
	
	-- ENTITY --
	component SRISC_CPU is
		port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			instruction	: in  STD_LOGIC_VECTOR (11 downto 0);
			prog_addr	: out STD_LOGIC_VECTOR (9 downto 0);
			io_din		: in  STD_LOGIC_VECTOR (7 downto 0);
			io_dout		: out STD_LOGIC_VECTOR (7 downto 0);
			io_addr		: out STD_LOGIC_VECTOR (3 downto 0);
			io_wren		: out STD_LOGIC;
			io_rden		: out STD_LOGIC
		);
	end component;
	
	-- FUNCTIONS --
	impure function READ_BIN_FILE(the_file_name: in string) return INST_TYPE;
	
end srisc;

package body srisc is

	-- FUNCTIONS --	
	impure function READ_BIN_FILE(the_file_name: in string) return INST_TYPE is		
		file     in_file:    text open read_mode is the_file_name;
		variable ram_data:   INST_TYPE;
		variable input_line: line;
	begin
		for i in 0 to 1023 loop
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
	
end srisc;