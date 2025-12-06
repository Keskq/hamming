`include "hamming_if.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

// Include all UVM components
`include "hamming_sequencer.sv"
`include "hamming_driver.sv"
`include "hamming_monitor.sv"
`include "hamming_agent.sv"
`include "hamming_scoreboard.sv"
`include "hamming_env.sv"
`include "hamming_test.sv"

`include "hamming_ref.sv"
`include "hamming_ref_if.sv"
`include "hamming_coverage.sv" // הוספת קובץ כיסוי

module hamming_tb_top;
	import uvm_pkg::*;

	// Interface declaration
	hamming_if vif();
    hamming_ref_if ref_vif();

	// Connects the Interface to the DUT
    hamming dut(vif.sig_clock, vif.sig_x, vif.sig_z);
    hamming_ref ref_u1(ref_vif.sig_clock, ref_vif.sig_x, ref_vif.sig_z);

    // Coverage module instance
    hamming_coverage coverage_inst (
        .clk(vif.sig_clock),
        .x(vif.sig_x),
        .z(vif.sig_z)
    );

	initial begin
		// Registers the Interface in the configuration block
		uvm_resource_db#(virtual hamming_if)::set (.scope("ifs"), .name("hamming_if"), .val(vif));
        uvm_resource_db#(virtual hamming_ref_if)::set (.scope("ifs"), .name("hamming_ref_if"), .val(ref_vif));

		// Execute the test
        run_test("hamming_test");
	end

	// Variable initialization
	initial begin
		vif.sig_clock <= 1'b1;
        ref_vif.sig_clock <= 1'b1;
	end

	// Clock generation
	always #5 vif.sig_clock = ~vif.sig_clock;
    always #5 ref_vif.sig_clock = ~ref_vif.sig_clock;

    // Enable waveform dumping
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  

endmodule

