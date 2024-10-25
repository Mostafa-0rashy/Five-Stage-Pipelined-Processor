LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PC IS
    PORT (
        clk, reset, enable : IN  std_logic;
        pcSel_jump : IN std_logic;
	pcSel_jz : IN std_logic;
	Rsel : IN std_logic;
	z_flag : IN std_logic;
	jmp_Cond:IN std_logic;
	Call_Cond : in std_logic;
 	jz_cond: in std_logic;
        pcData : IN std_logic_vector(31 DOWNTO 0);
	pcRet: in std_logic_vector(31 DOWNTO 0);
       	int_sig: In std_logic;
	int_address: In std_logic_VECTOR(31 downto 0);
        pc_Address : OUT std_logic_vector(31 DOWNTO 0);
	PC_push:	OUT std_logic_vector(31 DOWNTO 0);
	start_address:		IN std_logic_vector(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE PC_design OF PC IS
    SIGNAL pc_reg : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk, reset)
        VARIABLE pcINC: std_logic_vector(31 DOWNTO 0);
    BEGIN
        IF reset = '1' THEN
            pc_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                pcINC := std_logic_vector(unsigned(pc_reg)+1);
                IF pcSel_jump = '1' and (jmp_Cond ='1' or Call_Cond ='1') THEN
                    pc_reg <= pcData;
		elsif pcSel_jz = '1' and jz_cond ='0' then
			if Z_flag ='1' then
				pc_reg <= pcData;
			else
				pc_reg <= pcINC;
			end if;
		elsif Rsel='1' then
			pc_reg <= pcRet;
                ELSE
                   	pc_reg <= pcINC;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    pc_Address <= pc_reg;
END PC_design;

