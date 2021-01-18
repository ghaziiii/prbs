--************************************************************************
--* design name:   tb_prbs_gen_15_14
--*
--* @ target device:  xilinx kc705
--* 
--*
--*
--* description:
--*            This module is a testbench for pseudo-random generator 
--*            polynomial S(x)= x^15 + x^14 + 1
--*
--*            @clk       		: input, clock signal
--*            @rst				: input, synchronous reset, active high
--*            @enable       	: input, enable, active high
--*            @inject_error	: input, invert output, active high
--             @d_out     		: output, pseudo random data out
--*
--*      @author Ghazi Aoussaji
--*      @version 1.0
--*      @date created 02/11/20
---------------------------------------------------------------------
-- libraries declarations
library ieee  ;
use ieee.std_logic_1164.all  ;
use ieee.std_logic_arith.all  ;
use ieee.std_logic_unsigned.all  ;



entity tb_prbs_gen_15_14 is
end entity;


architecture rtl of tb_prbs_gen_15_14 is
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
	signal inject_error			: std_logic;
	signal d_out				: std_logic_vector(3 downto 0);
	signal ready_out			: std_logic;
	signal mode					: std_logic;
	
	begin
	------------------------------------------------------------------------------------------
	-- combinatorial
	------------------------------------------------------------------------------------------
	clk <= not clk after ( clk_period / 2.0 );
	--
	------------------------------------------------------------------------------------------
	-- components instantiation
	------------------------------------------------------------------------------------------

	prbs_gen_15_14_u0 : entity work.prbs_gen_15_14

	port map ( 
		clk       		=> clk,       	
		rst       		=> rst ,      	
		enable      	=> enable,      
		inject_error	=> inject_error,
		mode			=> mode,
		d_out     		=> d_out,
		ready_out		=> ready_out

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
	  wait for clk_period*2000;
	  enable <= '0';
	  wait for clk_period*20;
	  enable <= '1';
	  wait for clk_period*600;
	  enable <= '0';
	  wait for clk_period*20;
	  enable <= '1';
	  wait;
	end process;

	process
	begin
	  inject_error <= '0';
	  wait for clk_period*400;
	  inject_error <= '1';
	  wait for clk_period*2;
	end process;
	
	process
	begin
	  mode <= '0';
	  wait for clk_period*600;
	  mode <= '1';
	  wait for clk_period*600;
	end process;




end architecture;
