class hamming_agent extends uvm_agent;
	`uvm_component_utils(hamming_agent)
  
    uvm_analysis_port#(hamming_transaction) agent_ap_dut;
    uvm_analysis_port#(hamming_transaction) agent_ap_ref;

	hamming_sequencer	hm_seqr;
	hamming_driver		hm_drvr;
	hamming_monitor_dut	hm_mon_dut;
  	hamming_monitor_ref	hm_mon_ref;


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      
        agent_ap_dut = new(.name("agent_ap_dut"), .parent(this));
        agent_ap_ref = new(.name("agent_ap_ref"), .parent(this));

		hm_seqr		= hamming_sequencer::type_id::create(.name("hm_seqr"), .parent(this));
		hm_drvr		= hamming_driver::type_id::create(.name("hm_drvr"), .parent(this));
		hm_mon_dut	= hamming_monitor_dut::type_id::create(.name("hm_mon_dut"), .parent(this));
        hm_mon_ref	= hamming_monitor_ref::type_id::create(.name("hm_mon_ref"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		hm_drvr.seq_item_port.connect(hm_seqr.seq_item_export);
        hm_mon_dut.mon_ap_dut.connect(agent_ap_dut);
        hm_mon_ref.mon_ap_ref.connect(agent_ap_ref) ;
	endfunction: connect_phase
endclass: hamming_agent
