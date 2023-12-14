library verilog;
use verilog.vl_types.all;
entity ELEVADOR_vlg_sample_tst is
    port(
        EQ              : in     vl_logic;
        GT              : in     vl_logic;
        LT              : in     vl_logic;
        ST              : in     vl_logic_vector(2 downto 0);
        sampler_tx      : out    vl_logic
    );
end ELEVADOR_vlg_sample_tst;
