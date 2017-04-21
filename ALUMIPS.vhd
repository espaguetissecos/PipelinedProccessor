----------------------------------------------------------------------
-- Fichero: ALUMIPS.vhd
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALUMIPS is
	port (
		Op1 : in std_logic_vector(31 downto 0); -- Dato de entrada RT
		Op2 : in std_logic_vector(31  downto 0); -- Direcci�n RT
		ALUControl : in std_logic_vector(3 downto 0); -- Direcci�n RS
		Res : out std_logic_vector(31 downto 0); -- Salida RS
		Equal : out std_logic -- Salida Igual
	); 
end ALUMIPS;

architecture Practica of ALUMIPS is

signal sigSlti : std_logic_vector(31 downto 0);
signal sigRes : std_logic_vector(31 downto 0);
signal sigLui : std_logic_vector(31 downto 0);
signal sigEqual : std_logic;

begin


sigSlti <= x"00000001" when signed(Op1)<signed(Op2) else
			 x"00000000";	 
			 
sigEqual <= '1' when Op1=Op2 else 
			'0';

sigLui(31 downto 16) <= Op2(15 downto 0);
sigLui(15 downto 0) <= "0000000000000000";
		
	with ALUControl select
		sigRes <= Op1 and Op2 when "0000",
				 Op1 or Op2 when "0001",
				 Op1 xor Op2 when "0010",
				 Op1+Op2 when "0011",
				 Op1-Op2 when "1000",
				 sigLui when "1001",
				 sigSlti when "1010",
				 x"00000000" when others;

	


	Res <= sigRes;
	Equal <= sigEqual;
	
end Practica;


