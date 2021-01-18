--******************************************************************************
--* design name      :  Model
--*
--* target device    :  Not Specified
--* tool versions    :  QuestaSim  
--*
--* description      :  This unit is my VHDL design for channel selection
--*
--* ports	 		 	: data_in   			: input, input data
--*           			: sel					: input, channel select input 
--*						: data_out				: output, output data
--* author 			 :  Ghazi Aoussaji
--* version 		 :  1.0
--* date created 	 :  2020-11-16
--*
--******************************************************************************


-- Libraries declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-- use IEEE.numeric_std.all; -- use that, it's a better coding guideline
-- use IEEE.std_logic_arith.conv_std_logic_vector;


entity channel_mux is
	port	(
				-- inputs
				data_in					: in std_logic_vector(3 downto 0);
				sel						: in std_logic_vector(3 downto 0); 		-- 8 states
				-- outputs
				data_out				: out std_logic_vector(31 downto 0)	-- 8 channels

			);
end entity;

architecture rtl of channel_mux is
	------------------------------------------------------------------------------------------
	-- Constants declaration
	------------------------------------------------------------------------------------------
	
	
	------------------------------------------------------------------------------------------
	-- Types declaration
	------------------------------------------------------------------------------------------
	
	
	------------------------------------------------------------------------------------------
	-- Signals declaration
	------------------------------------------------------------------------------------------
	
	
	begin
	------------------------------------------------------------------------------------------
	-- Combinatorial
	------------------------------------------------------------------------------------------				
	data_out	<= 	x"0000000"&data_in 		when sel = "0000" else		-- Group0 channel 0
					x"000000"&data_in&x"0" 	when sel = "0001" else    	-- Group0 channel 1
					x"00000"&data_in&x"00" 	when sel = "0010" else    	-- Group1 channel 0
					x"0000"&data_in&x"000" 	when sel = "0011" else     	-- Group1 channel 1
					x"000"&data_in&x"0000" 	when sel = "0100" else     	-- Group2 channel 0
					x"00"&data_in&x"00000" 	when sel = "0101" else     	-- Group2 channel 1
					x"0"&data_in&x"000000" 	when sel = "0110" else     	-- Group3 channel 0
					data_in&x"0000000"      when sel = "0111" else      -- Group3 channel 1              
					x"00000000";		     		                    -- 	No data			

	

	
end architecture;
