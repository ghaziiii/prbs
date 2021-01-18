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

entity prbs7_32b is 
  port (
        clk       		: in  std_logic; --clock signal
        rst       		: in  std_logic; --reset signal
        enable      	: in  std_logic; --enable prbs active high
        d_out     		: out std_logic_vector(31 downto 0) --pseudo random data out
      );
end prbs7_32b;

architecture rtl of prbs7_32b is 

signal prbs_reg : std_logic_vector(31 downto 0):= (others => '1');
begin 

	--Data output
	d_out<= prbs_reg; 
  
  process(clk)
    begin
	if clk'event and clk='1' then
		if rst='1' then
			prbs_reg <= "10000011000010100011110010001011"; 
        else
			if enable='1' then 
				prbs_reg(31) <= prbs_reg(6) xor prbs_reg(5);
				prbs_reg(30) <= prbs_reg(5) xor prbs_reg(4);
				prbs_reg(29) <= prbs_reg(4) xor prbs_reg(3);
				prbs_reg(28) <= prbs_reg(3) xor prbs_reg(2);
				prbs_reg(27) <= prbs_reg(2) xor prbs_reg(1);
				prbs_reg(26) <= prbs_reg(1) xor prbs_reg(0);
				prbs_reg(25) <= prbs_reg(0) xor prbs_reg(6) xor prbs_reg(5);
				prbs_reg(24) <= prbs_reg(6) xor prbs_reg(4);-- 
				prbs_reg(23) <= prbs_reg(5) xor prbs_reg(3);
				prbs_reg(22) <= prbs_reg(4) xor prbs_reg(2);
				prbs_reg(21) <= prbs_reg(3) xor prbs_reg(1);
				prbs_reg(20) <= prbs_reg(2) xor prbs_reg(0);
				prbs_reg(19) <= prbs_reg(1) xor prbs_reg(6) xor prbs_reg(5);
				prbs_reg(18) <= prbs_reg(0) xor prbs_reg(4) xor prbs_reg(5);
				prbs_reg(17) <= prbs_reg(6) xor prbs_reg(5) xor prbs_reg(4) xor prbs_reg(3);
				prbs_reg(16) <= prbs_reg(5) xor prbs_reg(4) xor prbs_reg(3) xor prbs_reg(2);
				prbs_reg(15) <= prbs_reg(4) xor prbs_reg(3) xor prbs_reg(2) xor prbs_reg(1);
				prbs_reg(14) <= prbs_reg(3) xor prbs_reg(2) xor prbs_reg(1) xor prbs_reg(0);
				prbs_reg(13) <= prbs_reg(6) xor prbs_reg(5) xor prbs_reg(2) xor prbs_reg(1) xor prbs_reg(0);
				prbs_reg(12) <= prbs_reg(6) xor prbs_reg(4) xor prbs_reg(1) xor prbs_reg(0);
				prbs_reg(11) <= prbs_reg(6) xor prbs_reg(3) xor prbs_reg(0);
				prbs_reg(10) <= prbs_reg(6) xor prbs_reg(2);
				prbs_reg(9)  <= prbs_reg(1) xor prbs_reg(5);
				prbs_reg(8)  <= prbs_reg(4) xor prbs_reg(0);
				prbs_reg(7)  <= prbs_reg(6) xor prbs_reg(5) xor prbs_reg(3);
				prbs_reg(6)  <= prbs_reg(5) xor prbs_reg(4) xor prbs_reg(2);
				prbs_reg(5)  <= prbs_reg(4) xor prbs_reg(3) xor prbs_reg(1);
				prbs_reg(4)  <= prbs_reg(3) xor prbs_reg(2) xor prbs_reg(0);
				prbs_reg(3)  <= prbs_reg(6) xor prbs_reg(5) xor prbs_reg(2) xor prbs_reg(1);
				prbs_reg(2)  <= prbs_reg(5) xor prbs_reg(4) xor prbs_reg(1) xor prbs_reg(0);
				prbs_reg(1)  <= prbs_reg(6) xor prbs_reg(5) xor prbs_reg(4) xor prbs_reg(3) xor prbs_reg(0);
				prbs_reg(0)  <= prbs_reg(6) xor prbs_reg(4) xor prbs_reg(3) xor prbs_reg(2);

				
			else 
				prbs_reg <= prbs_reg;
			end if;
       end if;
    end if;
  end process; 
  
     
     
      

end rtl;
