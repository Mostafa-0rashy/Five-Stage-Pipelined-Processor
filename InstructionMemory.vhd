LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE IEEE.numeric_std.all;

ENTITY instructionMem IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        readAddress :       IN std_logic_vector(31 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0);
	int_address:        OUT std_logic_vector(31 DOWNTO 0);
	start_address:		OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY instructionMem;

ARCHITECTURE instructionMem_design OF instructionMem  IS 
    TYPE ram_type IS ARRAY(0 TO 2**12 - 1) OF std_logic_vector(15 DOWNTO 0);
        
    SIGNAL ram : ram_type ; 

BEGIN

    initialize_memory : PROCESS
    FILE memory_file : text OPEN READ_MODE IS "Out.mem";
    VARIABLE file_line : line;
    VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        FOR i IN ram'RANGE LOOP
            IF NOT endfile(memory_file) THEN
                readline(memory_file, file_line);
                read(file_line, temp_data);
                ram(i) <= temp_data;

            ELSE
                file_close(memory_file);
                WAIT;
            END IF;
        END LOOP;
    END PROCESS;

   
    process(clk, rst)
    begin
        IF rising_edge(clk) and rst='0' THEN
        instruction  <= ram(to_integer(unsigned(readAddress)));
 	
 	END IF;
    int_address <= ram(3)&ram(2);
    start_address<=ram(0);
    END PROCESS;

END instructionMem_design;
