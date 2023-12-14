library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LIFTER is
    port(
        -- Entradas do usuário
        CALL_0   : in bit;       -- Botão de chamada do térreo
        CALL_1   : in bit;       -- Botão de chamada do primeiro andar
		  INTERNAL : in bit;       -- Botão interno do elevador
        STOP     : in bit;       -- Botão de parada do LIFTER
        CLK      : in std_logic; -- Sinal de clock

        -- Estado atual do LIFTER (3 bits)
        ST : in bit_vector(2 downto 0);

        -- Sinais de comparação (LT: Menor, GT: Maior, EQ: Igual)
        LT, GT, EQ : in bit;

        -- Saídas do sistema
        openDoor   : out bit;                     -- Sinal para abrir a porta
        NS         : out bit_vector(2 downto 0);  -- Próximo estado do LIFTER (3 bits)
        statusElev : out bit_vector(1 downto 0);  -- Status do LIFTER (2 bits)

        -- Saídas para LEDs e LCD
        LED_0 : out bit;                    -- LED do térreo
        LED_1 : out bit;                    -- LED do primeiro andar
        LCD   : out bit_vector(3 downto 0)  -- LCD (andar atual do LIFTER)
    );
end LIFTER;

architecture main of LIFTER is
    signal SE1, SE2      : bit;             -- Sinais para indicar o status de elevação
    signal NS0, NS1, NS2 : bit;             -- Sinais para representar o próximo estado do LIFTER
    signal ST0, ST1, ST2 : bit;             -- Bits do estado atual do LIFTER
    signal currentFloor  : bit := '0';      -- Variável para armazenar o andar atual do LIFTER

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Lógica para determinar se ocorrerá uma elevação no estado
            SE1 <= ST0 and (not ST1) and (not ST2) and (not LT) and (GT xor EQ);
            SE2 <= (not ST0) and ST1 and ST2 and (not GT) and (LT xor EQ);

            -- Lógica para determinar se a porta deve ser aberta
            openDoor <= (not ST0) and (not ST1) and (((not ST2) and (not LT) and (not GT) and EQ) or (ST2 and (((not LT) and (not GT) and EQ) or ((not EQ) and (LT XOR GT)))));

            -- Lógica para determinar o próximo estado
            NS0 <= ST2 and (not LT) and GT and (ST0 xor ST1);
            NS1 <= ((not ST0) and ((ST2 and ((not ST1) and (not EQ) and (LT XOR GT))) or (ST1 and (not GT) and (LT XOR EQ)))) or (((not ST2) and (not GT) and ((not ST0) and ST1 and LT and (not EQ))) or (ST0 and (not ST1) and (not LT) and EQ));
            NS2 <= (not ST0) and (not GT) and (((not ST1) and (not LT) and EQ) or (ST1 and LT and (not GT) and (not EQ)));

            -- Atualizar o andar atual do LIFTER
            if (currentFloor = '0') then
                LED_0 <= '1';
                LED_1 <= '0';
            elsif (currentFloor = '1') then
                LED_0 <= '0';
                LED_1 <= '1';
            else
                LED_0 <= '0';
                LED_1 <= '0';
            end if;

            -- Atualizar o LCD
            LCD(0) <= currentFloor;

            -- Atualizar o status do LIFTER
            statusElev(0) <= SE1;
            statusElev(1) <= SE2;

            -- Atribuir os bits do próximo estado à saída NS
            NS(0) <= NS0;
            NS(1) <= NS1;
            NS(2) <= NS2;

            -- Lógica para controlar o andar atual do LIFTER
            if (CALL_0 = '1' and currentFloor = '0') then
                currentFloor <= '1';
            elsif (CALL_1 = '1' and currentFloor = '1') then
                currentFloor <= '0';
            elsif (INTERNAL = '1') then
                if currentFloor = '0' then
                    currentFloor <= '1';
                else
                    currentFloor <= '0';
                end if;
            end if;

            -- Lógica para parar o LIFTER
            if (STOP = '1') then
                NS <= ST;
            end if;
        end if;
    end process;

end architecture main;