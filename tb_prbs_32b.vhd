--************************************************************************
--* design name:   tb_prbs_gen_7_6
--*
--* @ target device:  xilinx kc705
--* 
--*
--*
--* description:
--*            This module is a testbench for pseudo-random generator 
--*            polynomial S(x)= x^7 + x^6 + 1
--*
--*            @clk       		: input, clock signal
--*            @rst				: input, synchronous reset, active high
--*            @enable       	: input, enable, active high
--*            @inject_error	: input, invert output, active high
--             @d_out     		: output, pseudo random data out
--*
--*      @author Ghazi Aoussaji
--*      @version 1.0
--*      @date created 02/11/21
---------------------------------------------------------------------
-- libraries declarations
library ieee  ;
use ieee.std_logic_1164.all  ;
use ieee.std_logic_arith.all  ;
use ieee.std_logic_unsigned.all  ;
use ieee.std_logic_textio.all;
use std.textio.all ;


entity tb_prbs7_32b is
end entity;


architecture rtl of tb_prbs7_32b is
	------------------------------------------------------------------------------------------
	-- constants declaration
	------------------------------------------------------------------------------------------
	constant clk_period 		: time 		:= 10 ns; -- 100 mhz

	------------------------------------------------------------------------------------------
	-- types declaration
	------------------------------------------------------------------------------------------


	------------------------------------------------------------------------------------------
	-- signals declaration
	------------------------------------------------------------------------------------------
	signal clk 					: std_logic := '1';
	signal rst 					: std_logic;
	signal enable				: std_logic;
	signal d_out				: std_logic_vector(31 downto 0);
	signal ready_out			: std_logic;

	begin
	------------------------------------------------------------------------------------------
	-- combinatorial
	------------------------------------------------------------------------------------------
	clk <= not clk after ( clk_period / 2.0 );
	--
	------------------------------------------------------------------------------------------
	-- components instantiation
	------------------------------------------------------------------------------------------

	prbs7_32b_u0 : entity work.prbs7_32b

	port map ( 
		clk    	=> clk,       	
		rst    	=> rst ,      	
		enable 	=> enable,      
		d_out  	=> d_out

	);




	------------------------------------------------------------------------------------------
	-- process
	------------------------------------------------------------------------------------------
	process
	begin
	  rst <= '1';
	  wait for clk_period*10;
	  rst <= '0';
	  wait;
	end process;


	process
	begin
	  enable <= '0';
	  wait for clk_period*20;
	  enable <= '1';
	  wait;
	end process;


	-- export output
	process (clk)
	constant path : string := "../output/prbs7_32b_output.txt";
	file output_file : text open write_mode is path;
	variable output_line : line;
	begin
	if rising_edge(clk) then
		if (enable ='1')then
			write(output_line, d_out);
			writeline(output_file, output_line);
		end if;
	end if;
	end process;




end architecture;
