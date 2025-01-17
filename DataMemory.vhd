LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE IEEE.numeric_std.all;
entity dataMem is
    port(
        clk:                  IN std_logic;
        rst,exception:        IN std_logic;
	sp  : 		      IN std_logic_vector (11 DOWNTO 0);
	Control_register_IN : IN std_logic_vector (15 downto 0);
	memaddress :          IN std_logic_vector (31 DOWNTO 0);--FROM ALU
	mem_value_in :        IN std_logic_vector (31 downto 0);
	mem_value_out:	      OUT std_logic_vector (31 downto 0);
	int_sig:	      IN std_logic;
	PUSH_PC:	      IN std_logic_vector (31 downto 0)
    );
end entity;

architecture dataMemDesign of dataMem is
    type ram_type is array(0 to 2**12 - 1) of std_logic_vector(31 downto 0);
    signal ram: ram_type;
    signal protect_free : std_logic_vector(0 to 2**12 - 1):= ( others => '0');
BEGIN
--
--    initialize_memory : PROCESS
--    FILE memory_file : text OPEN READ_MODE IS "memory.mem";
--    VARIABLE file_line : line;
--    VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
--    BEGIN
--        FOR i IN ram'RANGE LOOP
--            IF NOT endfile(memory_file) THEN
--                readline(memory_file, file_line);
--                read(file_line, temp_data);
--                ram(i) <= temp_data;
--
--            ELSE
--                file_close(memory_file);
--                WAIT;
--            END IF;
--        END LOOP;
--    END PROCESS;

process(clk, rst)
begin    
if (exception ='0') then
	
        	IF rst = '1' THEN
            		ram <= (others => (others => '0'));
			protect_free <=(others => '0');
		else
			if (Control_register_IN(9) ='1') then
				protect_free(to_integer(unsigned(memaddress))) <= '1';
			elsif(Control_register_IN(8) ='1') then
				protect_free(to_integer(unsigned(memaddress))) <= '0';	
			END IF;

			IF (Control_register_IN(10)='1') THEN --Memory Write 
				if (protect_free(to_integer(unsigned(memaddress))) = '0') then
				ram(to_integer(unsigned(memaddress)))<=mem_value_in;
				end if;
	    		ELSIF(Control_register_IN(1)='1') THEN --PUSH 
				ram(to_integer(unsigned(SP)))<=mem_value_in;
			ELSIF (Control_register_IN(8) ='1') then
				ram(to_integer(unsigned(memaddress)))<=X"00000000";
			ELSIF (Control_register_IN(11)='1') THEN -- Memory read
				mem_value_out<=ram(to_integer(unsigned(memaddress)));
                        ELSIF(Control_register_IN(0)='1') THEN -- POP
				mem_value_out<=ram(to_integer(unsigned(SP))+1);		
			ELSIF(int_sig='1') THEN--PUSH PC INT CASE
				ram(to_integer(unsigned(SP)))<=PUSH_PC;
			END IF;				
	
		END IF;
END IF;
end process;       
end dataMemDesign;
