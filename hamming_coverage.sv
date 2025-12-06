
module hamming_coverage(input clk, input [7:1] x, input [11:1] z);

    covergroup cg @(posedge clk);
      
      option.per_instance=1;
        coverpoint x {
            bins all_zeros = {7'b0000000};  
            bins all_ones  = {7'b1111111};  
            bins random_vals[] = {[7'b0000001:7'b1111110]}; 
        }

        coverpoint z {
            bins valid_outputs[] = {[11'b00000000001:11'b11111111110]}; 
        }

        cross x, z; 
    endgroup

    
    cg coverage = new();

    
    function void sample();
        `uvm_info("COVERAGE", $sformatf("Sampling coverage: sig_x=%b, sig_z=%b", x, z), UVM_MEDIUM);
    endfunction

    
    always @(posedge clk) begin
        sample();  
        coverage.sample();  
    end

endmodule
