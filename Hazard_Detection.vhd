LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

Entity Hazard_Detection IS 
PORT
(
clk: std_logic;
Rdst_address_in_exec: in std_logic_vector (2 downto 0);
Rsrc1_address_in_decode: in std_logic_vector (2 downto 0);
Rsrc2_address_in_decode: in std_logic_vector (2 downto 0);
Rdst_in_memory:  in std_logic_vector (2 downto 0);--for load data hazard
data_forward_alu_alu:in std_logic_vector (31 downto 0);

data_hazard:	out std_logic;
stall:		out std_logic;
forward_operand: out std_logic;
forward_data:	 out std_logic_vector (31 downto 0)
);
END Hazard_Detection;
ARCHITECTURE Hazard_Detection_Arch OF Hazard_Detection IS
signal counter: std_logic_vector(1 downto 0):="11";
BEGIN
    PROCESS (Rdst_address_in_exec, Rsrc1_address_in_decode, Rsrc2_address_in_decode,clk)
	
    BEGIN
	If(rising_edge(clk)) THEN
        IF ((Rdst_address_in_exec = Rsrc1_address_in_decode OR Rdst_address_in_exec = Rsrc2_address_in_decode)and Rdst_address_in_exec/="UUU" and counter/=0) THEN
            data_hazard <= '1';  
	    if(Rdst_address_in_exec = Rsrc1_address_in_decode) then
		forward_operand<='0';
		END IF;
 		if(Rdst_address_in_exec = Rsrc2_address_in_decode) then
		forward_operand<='1';
		END IF;

	stall<='1';		 -- Stall the pipeline
	counter<=counter -"01";
        ELSE
            data_hazard <= '0';  -- No stall
		stall<='0';
        END IF;
forward_data<=data_forward_alu_alu;
END IF;
counter <="11";
    END PROCESS;
END Hazard_Detection_Arch;
