--************************************************************************
--* design name:   prbs_7_6_top
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity prbs_7_6_top is
    port (
          clk 				: in  std_logic;
		  rst				: in std_logic;
		  enable			: in std_logic;
		  inject_error 		: in  std_logic;
		  data_out			: out std_logic_vector(3 downto 0);
		  error_out			: out std_logic_vector(3 downto 0);
		  error_count		: out std_logic_vector(40 downto 0)
          );
end prbs_7_6_top;

architecture behavioral of prbs_7_6_top is




signal d_out_i 			: std_logic_vector(3 downto 0);
signal error_out_i 		: std_logic_vector(3 downto 0);
signal rdy_out_i		: std_logic;
signal error_count_i 	: std_logic_vector(40 downto 0);
signal ready_out_i		: std_logic;


begin


data_out 	<= d_out_i;
error_out 	<= error_out_i;
error_count <= error_count_i;

   ----------------------------------------------		
	-- instantiate the prbs generator
   ----------------------------------------------		
	prbs_gen_7_6_u0 : entity work.prbs_gen_7_6

	port map ( 
				clk       		=> clk,       	
				rst       		=> rst ,      	
				enable      	=> enable,      
				inject_error	=> inject_error,
				mode			=> '1',
				d_out     		=> d_out_i,
				ready_out		=> ready_out_i
	);
   
   
   ----------------------------------------------		
	-- instantiate the checker with 8 bits input
   ----------------------------------------------
	prbs_check_7_6_u0 : entity work.prbs_check_7_6

	port map ( 
				rst          	=> rst ,       	
				clk          	=> clk,      	
				enable       	=> ready_out_i,      
				prbs_word_in 	=> d_out_i,
				err_out      	=> error_out_i,
				error_count		=> error_count_i,
				rdy_out      	=> rdy_out_i
	);	
   
   
 
  
end behavioral;

