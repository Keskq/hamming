class hamming_env extends uvm_env;
	`uvm_component_utils(hamming_env)

	hamming_agent hm_agent;
  	hamming_scoreboard hm_sb;


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		hm_agent	= hamming_agent::type_id::create(.name("hm_agent"), .parent(this));
        hm_sb = hamming_scoreboard::type_id::create(.name("hm_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
        hm_agent.agent_ap_dut.connect(hm_sb.sb_export_dut);
        hm_agent.agent_ap_ref.connect(hm_sb.sb_export_ref) ;
	endfunction: connect_phase
endclass: hamming_env
