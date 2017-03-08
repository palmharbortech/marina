`timescale 1 ns/10 ps

module debouncer
  (
   input      clk,      // this is a 50MHz clock provided on FPGA pin PIN_Y2
   input      PB,       // this is the input to be debounced
   output reg PB_state  // this is the debounced switch
   );

   initial
     begin
        PB_state = 1'b1;
     end

   // Synchronize the switch input to the clock
   reg        PB_sync_0;
   always @(posedge clk)
     PB_sync_0 <= PB;
   
   reg        PB_sync_1;
   always @(posedge clk)
     PB_sync_1 <= PB_sync_0;

   // Debounce the switch
   reg [15:0] PB_cnt;
   always @(posedge clk)
     if (PB_state == PB_sync_1)
       PB_cnt <= 0;
     else
       begin
          PB_cnt <= PB_cnt + 1'b1;
          if (PB_cnt == 16'hffff)
            PB_state <= ~PB_state;
       end
endmodule
