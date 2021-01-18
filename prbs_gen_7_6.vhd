--************************************************************************
--* design name:   prbs_gen_7_6
--*
--* @ target device:  xilinx kc705
--* 
--*
--*
--* description:
--*            This module is a pseudo-random generator 
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
--*      @date created 02/11/20
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.std_logic_unsigned.all;

entity prbs_gen_7_6 is 
	port (
				clk       		: in  std_logic; --clock signal
				rst       		: in  std_logic; --reset signal
				enable      	: in  std_logic; --enable prbs active high
				inject_error	: in  std_logic; -- invert feedback bit when high
				mode			: in  std_logic; -- 0 for fixed number, 1 for continuos mode
				d_out     		: out std_logic_vector(3 downto 0); --pseudo random data out, 
				ready_out		: out std_logic
			);
end prbs_gen_7_6;

architecture rtl of prbs_gen_7_6 is 
	------------------------------------------------------------------------------------------
	-- Signals declaration
	------------------------------------------------------------------------------------------
	signal prbs_reg 		: std_logic_vector(6 downto 0):= "1000000";
	signal enable_r			: std_logic;
	signal trig				: std_logic;
	signal counter			: std_logic_vector(40 downto 0); -- internal bit counter
	signal ready_out_vect	: std_logic_vector(6 downto 0);
	
	begin 
	------------------------------------------------------------------------------------------
	-- Combinatorial
	------------------------------------------------------------------------------------------	
	--Data output
	d_out		<= prbs_reg(6 downto 3);
	ready_out	<= ready_out_vect(6);
	------------------------------------------------------------------------------------------
	-- Synchronous process
	------------------------------------------------------------------------------------------
	
	-- trigger signal generation and internal counter increment 
    process(clk,rst )
    begin
	  if rst = '1' then
		enable_r			<= '0';
		trig				<= '0';
		ready_out_vect 		<= (others=>'0');
		counter				<= (others=>'0');
	  elsif clk'event and clk='1' then
		enable_r			<= enable;
		ready_out_vect 		<= ready_out_vect(5 downto 0)&trig;
		if ((enable = '1') and (enable_r = '0')) then -- enable rising edge
		  trig <= '1';
		elsif counter(40) = '1' then
		  trig 		<= '0';
		end if;
		if trig = '1' then
		  counter 	<= counter + 1;
		else 
		  counter 	<= (others=>'0');
		end if;
	  end if;
	end process; 
	
	
	
	process(clk)
    begin
	  if rst='1' then
		prbs_reg			<= "1000000";
	  elsif clk'event and clk='1' then
		if ((trig ='1') or ((mode = '1') and (enable = '1'))) then 
		  prbs_reg <= prbs_reg(5 downto 0)&((prbs_reg(6) xor prbs_reg(5)) xor inject_error);
		else 
		  prbs_reg <= prbs_reg;
		end if;
	  end if;
	end process; 
	
	
	end rtl;
	