LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY SP IS
	PORT ( clk,reset : IN  std_logic;
	  Push: IN std_logic;
	  Pop: IN std_logic;
	  sp  : OUT std_logic_vector(11 DOWNTO 0)
        );
END SP;

ARCHITECTURE SP_design OF SP IS

signal curSP: STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";


begin


process(clk)
begin
  if rising_edge(clk) then
    if reset = '1' then
      curSP <= (others => '1');
    else
      if Pop = '1' then
        curSP <= curSP + "000000000001"; 
      elsif push = '1' then
        curSP <= curSP - "000000000001"; 
      end if;
    end if;
  end if;
end process;
SP <= curSP;
		
END SP_design;
