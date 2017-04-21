  ----------------------------------------------------------------------------------------------
-- Fichero: procesador.vhd 
-- Descripción: Microprocesador Uniciclo
-- pareja 06
---------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;


-- Entidad de señales de procesador

entity procesador is
    
    port (
        Clk: in std_logic;                                                  -- Reloj
        Reset: in std_logic;                                     -- Reset activo a nivel bajo

        I_Addr: out std_logic_vector(31 downto 0);             -- Dirección para la memoria de programa
        I_DataIn: in std_logic_vector(31 downto 0);              -- Código de operación

        D_DataIn: in std_logic_vector(31 downto 0);          -- Salida de memoria de datos MemDataDataRead
        D_WrEn: out std_logic;                                           -- Habilitación de escritura en la memoria de datos
        D_Addr: out std_logic_vector(31 downto 0);             -- Dirección de la memoria de datos
        D_DataOut: out std_logic_vector(31 downto 0)         -- Dato de escritura de la memoria de datos
    );
    end procesador;


-- Arquitectura de procesador

architecture Practica of procesador is


-- Señales auxiliares para las salidas de la Unidad de Control

    signal SigOPCode: std_logic_vector (31 downto 26);              -- Señal auxiliar de OPCode
    signal SigFunct: std_logic_vector (5 downto 0);                 -- Señal auxiliar de Funct
    signal SigMemToReg: std_logic;                                      -- Señal auxiliar de MemToReg
    signal SigMemWrite: std_logic;                                      -- Señal auxiliar de MemWrite
    signal SigALUControl: std_logic_vector (3 downto 0);            -- Señal auxiliar de ALUControl
    signal SigALUSrc: std_logic;                                            -- Señal auxiliar de ALUSrc
    signal SigRegDest: std_logic;                                           -- Señal auxiliar de RegDest
    signal SigRegWrite: std_logic;                                      -- Señal auxiliar de RegWrite
  
    
    signal SigI_DataIn : std_logic_vector(31 downto 0);      -- Señal auxiliar de I_DataIn
    signal SigD_DataIn: std_logic_vector(31 downto 0);   -- Señal auxiliar de D_DataIn
    signal SigPCSrc: std_logic_vector(1 downto 0);              -- Señal auxiliar de PCSrc
    
    
-- Señales de la ALU
    
    signal SigD_Addr:std_logic_vector(31 downto 0);            -- Señal auxiliar de la salida D_Addr
    signal SigOp2: std_logic_vector(31 downto 0);                   -- Señal auxiliar del openando 2 de la ALU
    signal SigPCIn: std_logic_vector(31 downto 0);                  -- Señal auxiliar de la entrada al PC
    signal SigPC: std_logic_vector(31 downto 0);                        -- Señal auxiliar en la que se almacena el PC actual más 4
    signal SigEqual: std_logic;                                                 -- Señal auxiliar de la bandera Equal
    
    
-- Señal que hace las veces de salida del microprocesador y de entrada del PC a la que se le sumará 4

    signal SigI_Addr: std_logic_vector(31 downto 0) := (others => '0');
    
    
-- Señal para extender en signo los bits  del 0 al 15 de la entrada I_DataIn del microprocesador

    signal SigExtSig: std_logic_vector(31 downto 0); 
    
    
-- Señales del Banco de Registros
    
    signal SigRd1: std_logic_vector(31 downto 0);                   -- Lectura 1 del registro
    signal SigRd2: std_logic_vector(31 downto 0);                   -- Lectura 2 del registro
    signal SigWd3: std_logic_vector(31 downto 0);                   -- Entrada de escritura del GPR
    signal SigA3: std_logic_vector(20 downto 16);                   -- Señal auxiliar de la entrada A3 
	 signal SigEqualRegs: std_logic;									-- Señal auxiliar para logica de salto




	
	--IF-ID
	
	signal SigI_DataIn_ID	: std_logic_vector(31 downto 0);
	signal SigPC_ID	: std_logic_vector(31 downto 0);
	
	--ID-EX
	
	signal SigRd1_EX   : std_logic_vector(31 downto 0);
	signal SigRd1_FU   : std_logic_vector(31 downto 0);
	signal SigRd2_EX   : std_logic_vector(31 downto 0);
	signal SigRd2_FU   : std_logic_vector(31 downto 0);
	signal SigExtSig_EX   : std_logic_vector(31 downto 0);
	signal SigA3_EX	: std_logic_vector(20 downto 16);
	signal SigRegWrite_EX	: std_logic;
	signal SigMemtoReg_EX	: std_logic;
	signal SigMemWrite_EX	: std_logic;
	signal SigALUSrc_EX	: std_logic;
	signal SigALUControl_EX	: std_logic_vector(3 downto 0);
	signal SigA1_EX : std_logic_vector(25 downto 21);
	signal SigA2_EX : std_logic_vector(20 downto 16);
	signal SigOP_EX : std_logic_vector(31 downto 26);
	
	--EX-MEM
	
	signal SigRegWrite_MEM	: std_logic;
	signal SigMemtoReg_MEM	: std_logic;
	signal SigMemWrite_MEM	: std_logic;
	signal SigRes_MEM	: std_logic_vector(31 downto 0);
	signal SigA3_MEM	: std_logic_vector(20 downto 16);
	signal SigRd2_MEM   : std_logic_vector(31 downto 0);
	
	--MEM-WB
	signal SigRegWrite_WB	: std_logic;
	signal SigMemtoReg_WB	: std_logic;
	signal SigRes_WB	: std_logic_vector(31 downto 0);
	signal SigD_DataIn_WB : std_logic_vector(31 downto 0);
	signal SigA3_WB	: std_logic_vector(20 downto 16);
	
	

	--Hazard Detection Unit
	signal SigPCWrite	: std_logic;
	signal SigIFIDWrite	: std_logic;
	signal SigExBubbleWrite	: std_logic;


	--Forwarding Unit
	signal SigRd1Mux	: std_logic_vector(1 downto 0);
	signal SigRd2Mux	: std_logic_vector(1 downto 0);
	
	--Branch
	


	
-- Componente del módulo UnidadControl

component UnidadControl is 
    port( 
        OPCode : in std_logic_vector (31 downto 26);                -- Entrada de OPCode
        Funct : in std_logic_vector (5 downto 0);                       -- Entrada de Funct
        MemToReg: out std_logic;                                            -- Salida de MemToReg
        MemWrite: out std_logic;                                            -- Salida de MemWrite
        ALUControl: out std_logic_vector (3 downto 0);              -- Salida de ALUControl de 3 bits
        ALUSrc: out std_logic;                                              -- Salida de ALUSrc
        RegDest: out std_logic;                                             -- Salida de RedDest
        RegWrite: out std_logic;                                            -- Salida de RegWrite
        PCSrc: out std_logic_vector (1 downto 0)
		  );
end component;


-- Componente del módulo AluMIPS
    
component AluMIPS is 
    port (
        Op1: in std_logic_vector(31 downto 0);                      -- Operando 1
        Op2: in std_logic_vector(31 downto 0);                      -- Operando 2
        ALUControl: in std_logic_vector(3 downto 0);                -- Señal de control de la operación que debe ejectura la ALU
        Res: out std_logic_vector(31 downto 0);                         -- Resultado
        Equal: out std_logic                                                        -- Bandera de estado Equal, que se hace 1 cuando Res es 0
    );
end component;


-- Componente del módulo RegsMIPS

component RegsMIPS is 
    port (
        Clk: in std_logic;                                                  -- Reloj
        Reset: in std_logic;                                                     -- Reset asíncrono a nivel bajo
        We3: in std_logic;                                                  -- Enable para escritura
        Wd3: in std_logic_vector(31 downto 0);                      -- Dato a escribir en la dirección A3
        A1: in std_logic_vector(4  downto 0);                           -- Primer registro a leer
        A2: in std_logic_vector(4 downto 0);                            -- Segundo registro a leer
        A3: in std_logic_vector(4 downto 0);                            -- Dirección del registro a escribir    
        Rd1: out std_logic_vector(31 downto 0);                         -- Primera salida del registro
        Rd2: out std_logic_vector(31 downto 0)                      -- Segunda salida del registro
    ); 
end component;


begin

                         -- La entrada OPCode son los bits del 31 al 26 de la misma señal
    SigI_DataIn <= I_DataIn;                                      -- Asignamos a la entrada una señal auxiliar
    D_WrEn <= SigMemWrite_MEM;                                               -- Señal auxiliar con la que haremos que la señal de la Unidad de Control MemWrite controle la escritura en la memoria de datos como una salida de la entidad de nuestro Micro_MIPS
    SigD_DataIn <= D_DataIn;                              -- Bus auxiliar que nos permitirá leer de la memoria de datos
    D_Addr <= SigRes_MEM;                                      -- Dirección de escritura y lectura de la memoria de datos
    D_DataOut <= SigRd2_MEM;                                         -- Bus a escribir en la memoria de datos, que viene dado por la segunda señal de lectura del GPR (rt)
    I_Addr <= SigI_Addr;                                    -- Asignamos a nuestra salida la señal auxiliar que utilizamos para el PC

	 SigFunct <= SigI_DataIn_ID(5 downto 0);                         -- La entrada Funct de la Unidad de control son los bits del 5 al 0 de la instrucción que se está ejectuando (I_DataIn)
	 SigOPCode <= SigI_DataIn_ID(31 downto 26); 

-- Asignacion de señales a las entradas y salidas del componente UnidadControl
                
    UC: UnidadControl Port Map (    
        OPCode => SigOPCode,
        Funct => SigFunct,
        MemToReg => SigMemToReg,
        MemWrite => SigMemWrite,
        ALUControl => SigALUControl,
        ALUSrc => SigALUSrc,
        RegDest => SigRegDest,
        RegWrite => SigRegWrite,
		  PCSrc => SigPCSrc
    );              

    
-- Asignacion de señales a las entradas y salida del componente AluMIPS

    ALU: AluMIPS Port Map (         
        Op1 => SigRd1_FU,                  
        Op2 => SigOp2,                  
        Res => SigD_Addr,
        ALUControl => SigALUControl_EX,    
        Equal => SigEqual
    );          

        
-- Asignacion de señales a las entradas y salidas del componente RegsMIPS
        
    REG: RegsMIPS Port Map (    
        Clk => Clk,
        Reset => Reset,
        We3 => SigRegWrite_WB,             
        Wd3 => SigWd3,
        A1 => SigI_DataIn_ID (25 downto 21),
        A2 => SigI_DataIn_ID (20 downto 16),
        A3 => SigA3_WB,
        Rd1 => SigRd1,
        Rd2 => SigRd2
    );
        
    
    process(Clk,Reset)
        begin
        if (Reset = '1') then                                -- Reset asíncrono
            SigI_Addr <= x"00000000";
				
        elsif rising_edge(Clk)  then
				if (SigPCWrite = '1') then 
					SigI_Addr <= SigPCIn;
					
				end if;
				
        end if;
    end process;
-- Proceso del Program Counter
--IF-ID

    process(Clk,Reset)
        begin
        if (Reset = '1') then                                -- Reset asíncrono
				SigPC_ID <= x"00000000";
				SigI_DataIn_ID <= x"00000000";  --Equivale a un NOP
				
        elsif rising_edge(Clk) then
				if (SigIFIDWrite = '1') then 
					SigI_DataIn_ID <= SigI_DataIn;
					SigPC_ID(31 downto 28) <= SigPC(31 downto 28);
				end if;
				
        end if;
    end process;
	 
--ID-EX
	 
	     process(Clk, Reset)
        begin
        if (Reset = '1') then                                -- Reset asíncrono
		            
				SigRd1_EX   <= (others=>'0');
				SigRd2_EX   <= (others=>'0');
				SigExtSig_EX   <= (others=>'0');
				SigA3_EX		<= (others=>'0');
				SigRegWrite_EX		<= '0';
				SigMemtoReg_EX		<= '0';
				SigMemWrite_EX		<= '0';
				SigALUSrc_EX		<= '0';
				SigALUControl_EX		<= (others=>'0');
				SigA1_EX <= (others=>'0');
				SigA2_EX <= (others=>'0');
				SigOP_EX <= (others=>'0');
			

					
        elsif rising_edge(Clk) then
				SigRd1_EX   <= SigRd1;
				SigRd2_EX   <= SigRd2;
				SigExtSig_EX   <= SigExtSig;
				SigA3_EX		<= SigA3;
				
				if (SigExBubbleWrite = '0') then
					SigRegWrite_EX		<= SigRegWrite;
					SigMemtoReg_EX		<= SigMemToReg;
					SigMemWrite_EX		<= SigMemWrite;
				else
					SigRegWrite_EX		<= '0';
					SigMemtoReg_EX		<= '0';
					SigMemWrite_EX		<= '0';
				end if;
				
				SigALUSrc_EX		<= SigALUSrc;
				SigALUControl_EX		<= SigALUControl;
				SigA1_EX <= SigI_DataIn_ID(25 downto 21);
				SigA2_EX <= SigI_DataIn_ID(20 downto 16);
				SigOP_EX <= SigI_DataIn_ID(31 downto 26);
				
        end if;
    end process;
    
 
	  process(SigRes_MEM, SigRd1Mux,SigRd2Mux,SigWd3,SigRd1_EX,SigRd2_EX)
	  begin
 
			if (SigRd1Mux = "01") then
				SigRd1_FU <= SigRes_MEM;
			elsif (SigRd1Mux = "10") then
				SigRd1_FU <= SigWd3;	
			else
				SigRd1_FU   <= SigRd1_EX;	
			end if;

			if (SigRd2Mux = "01") then
				SigRd2_FU <= SigRes_MEM;
			elsif (SigRd2Mux = "10") then
				SigRd2_FU <= SigWd3;	
			else
				SigRd2_FU   <= SigRd2_EX;	
			end if;	
	  end process;

--EX-MEM
	 
	     process(Clk, Reset)
        begin
        if (Reset = '1') then                                -- Reset asíncrono
           
				SigRd2_MEM   <= (others=>'0');
				SigA3_MEM		<= (others=>'0');
				SigRegWrite_MEM		<= '0';
				SigMemtoReg_MEM	<= '0';
				SigMemWrite_MEM		<= '0';
				SigRes_MEM		<= (others=>'0');
				
        elsif rising_edge(Clk) then
				
				SigRd2_MEM   <= SigRd2_EX;
				SigA3_MEM		<= SigA3_EX;
				SigRegWrite_MEM		<= SigRegWrite_EX;
				SigMemtoReg_MEM	<= SigMemtoReg_EX;
				SigMemWrite_MEM		<= SigMemWrite_EX;
				SigRes_MEM		<= SigD_Addr;
				
        end if;
    end process;
	 
	 
-- MEM-WB

	process(Clk, Reset)
        begin
			if (Reset = '1') then 
				SigRegWrite_WB	<= '0';
				SigMemtoReg_WB	<= '0';
				SigRes_WB <= (others=>'0');
				SigD_DataIn_WB <=(others=>'0');
				SigA3_WB	<= (others=>'0');
			elsif rising_edge(Clk) then
				SigRegWrite_WB	<= SigRegWrite_MEM;
				SigMemtoReg_WB	<= SigMemToReg_MEM;
				SigRes_WB <= SigRes_MEM;
				SigD_DataIn_WB <=SigD_DataIn;
				SigA3_WB	<= SigA3_MEM;			
				
			end if;
	  end process;
			
			
	 -- Proceso del Hazard Detection Unit
	 
	 process(SigI_DataIn_ID, SigA3_EX, SigRegWrite_EX, SigRegWrite_MEM, SigA3_MEM, SigRd1Mux, SigOP_EX)
		begin 
		
		
		if ((SigRd1Mux = "00") and (SigRd2Mux = "00")) then
		
			if ((SigRegWrite_EX= '1' ) and (SigA3_EX/="00000") and (SigOP_EX="100011") and(SigA3_EX = SigI_DataIn_ID (25 downto 21))) then 
				SigPCWrite <= '0';
				SigIFIDWrite <= '0';
				SigExBubbleWrite <= '1';	
			
			elsif ((SigRegWrite_EX= '1' ) and (SigA3_EX/="00000")  and (SigOP_EX="100011") and (SigA3_EX = SigI_DataIn_ID (21 downto 16))) then 
				SigPCWrite <= '0';
				SigIFIDWrite <= '0';
				SigExBubbleWrite <= '1';	
--
--			elsif ((SigRegWrite_MEM= '1' ) and (SigA3_MEM/="00000") and (SigA3_MEM = SigI_DataIn_ID (26 downto 21))) then 
--				SigPCWrite <= '0';
--				SigIFIDWrite <= '0';
--				SigExBubbleWrite <= '1';	
--
--				
--			elsif ((SigRegWrite_MEM= '1' ) and (SigA3_MEM/="00000") and (SigA3_MEM = SigI_DataIn_ID (21 downto 16))) then 
--				SigPCWrite <= '0';
--				SigIFIDWrite <= '0';
--				SigExBubbleWrite <= '1';	
			else
				SigPCWrite <= '1';
				SigIFIDWrite <= '1';
				SigExBubbleWrite <= '0';				
			end if;
			
		else
			SigPCWrite <= '1';
			SigIFIDWrite <= '1';
			SigExBubbleWrite <= '0';
		end if;		
				
	end process;	
			
			
	 -- Proceso de adelantamiento de registros
						
	process(SigRegWrite_MEM, SigA3_MEM, SigRes_MEM, SigI_DataIn_ID, SigWd3, SigA3_WB, SigRegWrite_WB,SigA1_EX, SigA2_EX)
		begin
				SigRd1Mux <= "00";
				SigRd2Mux <= "00";					
				if (SigRegWrite_MEM = '1') and (SigA3_MEM/="00000") then
					if (SigA3_MEM = SigA1_EX) then
						SigRd1Mux <= "01";
						-- SigRd1_EX <= SigRes_MEM;
					end if;
					
					if (SigA3_MEM = SigA2_EX) then
						SigRd2Mux <= "01";			
					--	SigRd2_EX <= SigRes_MEM;
						
					end if;					
				elsif (SigRegWrite_WB = '1') and (SigA3_WB/="00000") then
					if (SigA3_WB = SigA1_EX) then
						SigRd1Mux <= "10";			
					--	SigRd1_EX <= SigWd3;
					end if;
					if (SigA3_WB = SigA2_EX) then
						SigRd2Mux <= "10";						
						-- SigRd2_EX <= SigWd3;
					end if;		
				end if;
	end process;
	
    -- Proceso del sumador del Program Counter
    
    process(SigI_Addr)
        begin
					SigPC <= SigI_Addr + 4;				 
				 
     end process;
    
    
-- Logica de Salto unificada
    
    process(SigPCSrc, SigEqualRegs, SigPC_ID, SigI_DataIn_ID, SigExtSig, SigPC)
			begin
            case SigPCSrc is
					when "00" => SigPCIn <= SigPC;
					when "01" => SigPCIn <= SigPC_ID(31 downto 28) & SigI_DataIn_ID(25 downto 0) & "00"; 
					when "10" =>  case SigEqualRegs is 
											when '0' => SigPCIn <= (SigExtSig(29 downto 0) & "00") + SigI_Addr;
											when others => SigPCIn <= SigPC;
											end case;
					when others => case SigEqualRegs is 
											when '1' => SigPCIn <= (SigExtSig(29 downto 0) & "00") + SigI_Addr;
											when others => SigPCIn <= SigPC;
											end case;
            end case;
			end process;


-- Proceso de igualdad de ops

	process(SigRd1, SigRd2)
		begin
			if SigRd1 = SigRd2 then 
				SigEqualRegs <= '1';	
			else
				SigEqualRegs <= '0';
			end if;
		
		end process;
			
    
-- Proceso de  ALUSrc
    
    process(SigExtSig, SigRd2_EX, SigALUSrc_EX, SigExtSig, SigI_DataIn_ID, SigExtSig_EX, SigRd2_FU)
	 
        begin
		          
        SigExtSig(31 downto 16) <= (others => SigI_DataIn_ID(15));
        SigExtSig(15 downto 0) <= SigI_DataIn_ID(15 downto 0);
        
			case SigALUSrc_EX is 
				 when '0' => SigOp2 <= SigRd2_FU;
				 when others => SigOp2 <= SigExtSig_EX;		 
			end case;
			
    end process;
	 
 
    
-- Proceso de A3 del Banco de Registros
    
    process(SigI_DataIn_ID,SigRegDest)
        begin
    
            case SigRegDest is
                when '0' => SigA3 <= SigI_DataIn_ID(20 downto 16);
                when others => SigA3 <= SigI_DataIn_ID(15 downto 11);
            end case;

    end process;
    
    
-- Proceso de MemToReg y PCToReg
    
    process(SigD_DataIn_WB,SigRes_WB,SigMemToReg_WB)
        begin
            case SigMemToReg_WB is
                when '0' => SigWd3 <= SigRes_WB;
                when others => SigWd3 <= SigD_DataIn_WB;
            end case;
    end process;
                
end Practica;
