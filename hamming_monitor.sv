class hamming_monitor_dut extends uvm_monitor;
	`uvm_component_utils(hamming_monitor_dut)
    uvm_analysis_port#(hamming_transaction) mon_ap_dut;

	virtual hamming_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual hamming_if)::read_by_name (.scope("ifs"), .name("hamming_if"), .val(vif)));
        mon_ap_dut = new(.name("mon_ap_dut"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);

		hamming_transaction hm_tx;
		hm_tx = hamming_transaction::type_id::create (.name("hm_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge vif.sig_clock)
			begin
					hm_tx.z = vif.sig_z;
					hm_tx.x = vif.sig_x;
                    mon_ap_dut.write(hm_tx);

			end
		end
	endtask: run_phase
endclass: hamming_monitor_dut




class hamming_monitor_ref extends uvm_monitor;
	`uvm_component_utils(hamming_monitor_ref)
	uvm_analysis_port#(hamming_transaction) mon_ap_ref;

	virtual hamming_ref_if ref_vif;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual hamming_ref_if)::read_by_name (.scope("ifs"), .name("hamming_ref_if"), .val(ref_vif)));
		mon_ap_ref = new(.name("mon_ap_ref"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);

		hamming_transaction hm_tx;
		hm_tx = hamming_transaction::type_id::create (.name("hm_tx"), .contxt(get_full_name()));

		forever begin @(posedge ref_vif.sig_clock) 
                   begin 
                     hm_tx.z = ref_vif.sig_z;
                     hm_tx.x = ref_vif.sig_x; 
                     //Send the transaction to the analysis port
	                 mon_ap_ref.write(hm_tx);
                   end 
                end 
        endtask: run_phase endclass:

hamming_monitor_ref

