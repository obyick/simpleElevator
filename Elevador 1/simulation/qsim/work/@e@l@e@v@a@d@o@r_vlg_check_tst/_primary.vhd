library verilog;
use verilog.vl_types.all;
entity ELEVADOR_vlg_check_tst is
    port(
        NS              : in     vl_logic_vector(2 downto 0);
        openDoor        : in     vl_logic;
        statusElev      : in     vl_logic_vector(1 downto 0);
        sampler_rx      : in     vl_logic
    );
end ELEVADOR_vlg_check_tst;
