--************************************************************************
--* design name:   prbs_check_15_14
--*
--* @ target device:  xilinx kc705
--* 
--*
--*
--* description:
--*            This module is a pseudo-random generator 
--*            polynomial S(x)= x^15 + x^14 + 1
--*
--*            @clk         	: input, clock signal
--*            @rst           	: input, synchronous reset, active high
--*            @enable         	: input, enable, active high
--*            @prbs_word_in  	: input, data to be checked
--*            @err_out       	: output, error detected
--*            @error_count		: output, number of error detected
--*            @rdy_out       	: output, ready out
--* 
--*
--*      @author Ghazi Aoussaji
--*      @version 1.0
--*      @date created 02/11/20
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity prbs_check_15_14 is
    port (
        rst          		: in  std_logic;
        clk            		: in  std_logic;
        enable          	: in  std_logic;
        prbs_word_in      	: in  std_logic_vector(3 downto 0);
        err_out            	: out std_logic_vector(3 downto 0);
		error_count			: out std_logic_vector(40 downto 0);
		expected			: out std_logic;
        rdy_out            	: out std_logic
    );
end prbs_check_15_14;

architecture rtl of prbs_check_15_14 is

	constant STATS_CONFIG_c     : integer := 18;
	
	type checker_state_T is (waitForLock, Locked);
	
	signal status 				: checker_state_T;
	signal status_r 			: checker_state_T;
    signal feedback_reg         : std_logic_vector(14 downto 0);
    signal err_s                : std_logic_vector(3 downto 0);
    signal cnt_stats            : integer range 0 to STATS_CONFIG_c+1;
	signal counter				: std_logic_vector(40 downto 0);
	
begin
    
	
	expected  	<= feedback_reg(14)  xor feedback_reg(13);
    -- PRBS7 equation: x^15 + x^14 + 1
    checker_fsm_proc: process(rst, clk)
    begin
        if rst = '1' then
            status <= waitForLock;
            cnt_stats <= 0;
            
        elsif rising_edge(clk) then
            case status is
                when waitForLock =>
                    if err_s = "0000" and feedback_reg /= x"00" then
                        cnt_stats <= cnt_stats + 1;
                    else
                        cnt_stats <= 0;
                    end if;
                    
                    if cnt_stats= STATS_CONFIG_c then
                        status <= Locked;
                    end if;
                
                when Locked => 
					if err_s/= "0000" then
						status <= waitForLock;
					end if;
            end case;
        end if;
    end process;
    
    prbs7_proc: process(rst, clk)
    begin

        if rst = '1' then
            feedback_reg <= (others => '0');
            err_s        <= "0000";

        elsif rising_edge(clk) then
            if enable = '1' then
                err_s(3) <= (feedback_reg(14) xor feedback_reg(13)) xor prbs_word_in(0);  
                err_s(2) <= (feedback_reg(13) xor feedback_reg(12)) xor prbs_word_in(0);
				err_s(1) <= (feedback_reg(12) xor feedback_reg(11)) xor prbs_word_in(0);
				err_s(0) <= (feedback_reg(11) xor feedback_reg(10)) xor prbs_word_in(0);

                feedback_reg(14 downto 1) <= feedback_reg(13 downto 0);
                if status /= Locked then                    
                    feedback_reg(0) <= prbs_word_in(3);
                else
                    feedback_reg(0) <= (feedback_reg(14) xor feedback_reg(13));
                end if;
            end if;
        end if;
    end process;
	-- count number of error
	count_proc: process(rst, clk)
    begin

        if rst = '1' then
            counter 	<= (others => '0');
			status_r 	<= waitForLock;
        elsif rising_edge(clk) then
            if enable = '1' then
			status_r <= status;
                if ((status_r = Locked) and (status = waitForLock)) then                    
                    counter <= counter + 1;
                else
                    counter <= counter;
                end if;
            end if;
        end if;
    end process;
	
            
    err_out 		<= err_s;
    rdy_out 		<= '1' when status = Locked else '0';
	error_count 	<= counter;
            
end rtl;