--************************************************************************
--* design name:   tb_prbs_7_6_top
--*
--* @ target device:  xilinx kc705
--* 
--*
--*
--* description:
--*            This module is a testbench for pseudo-random generator 
--*            polynomial S(x)= x^7 + x^6 + 1
--*
--*            @clk 			: input, clock signal
--*            @rst				: input, synchronous reset, active high
--*            @enable		 	: input, enable, active high
--*            @inject_error	: input, invert output, active high
--*            @data_out		: output, pseudo random data out
--*            @error_out		: output, error detected
--*            @error_count		: output, number of error detected
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



entity tb_prbs_7_6_mux is
end entity;


architecture rtl of tb_prbs_7_6_mux is
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
	signal ready_out_i			: std_logic;
	signal sel_i				: std_logic_vector(3 downto 0);
	signal data_out_mux			: std_logic_vector(31 downto 0);
	
	begin
	------------------------------------------------------------------------------------------
	-- combinatorial
	------------------------------------------------------------------------------------------
	clk <= not clk after ( clk_period / 2.0 );
	--
	------------------------------------------------------------------------------------------
	-- components instantiation
	------------------------------------------------------------------------------------------

	prbs_gen_7_6_u0 : entity work.prbs_gen_7_6

	port map ( 
		clk 			=> clk,       	
		rst				=> rst ,      	
		enable			=> enable,      
		inject_error	=> inject_error,
		mode			=> '1',
		d_out			=> d_out,
		ready_out		=> ready_out_i
	);

	channel_mux_u0 : entity work.channel_mux

	port map (     
		-- inputs	
		data_in			=> d_out,
		sel				=> sel_i,
		-- outputs	
		data_out		=> data_out_mux

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

	process
	begin
	  inject_error <= '0';
	  wait for clk_period*400;
	  inject_error <= '1';
	  wait for clk_period*2;
	end process;
	
	process
	begin
	  sel_i <= "0000";
	  wait for clk_period*400;
	  sel_i <= "0001";
	  wait for clk_period*400;
	  sel_i <= "0010";
	  wait for clk_period*400;
	  sel_i <= "0011";
	  wait for clk_period*400;
	  sel_i <= "0100";
	  wait for clk_period*400;
	  sel_i <= "0111";
	  wait for clk_period*400;
	  sel_i <= "1111";
	  wait for clk_period*400;
	end process;




end architecture;
