// top
`define WAIT 0
`define READ 1
`define LENET 2
`define WRITE 3
`define DONE 4

// dma_read
// `define WAIT 3'd0
`define WEIGHT_CTRL_S 3'd1
`define WEIGHT_CTRL_R 3'd2
`define WEIGHT_CHNL 3'd3
`define ACT_CTRL_S 3'd4
`define ACT_CTRL_R 3'd5
`define ACT_CHNL 3'd6
`define FINISH 3'd7

// dma_write
// `define WAIT 3'd0
// `define ACT_CTRL_S 3'd4
// `define ACT_CTRL_R 3'd5
`define ACT_CHNL_S 3'd1
`define ACT_CHNL_R 3'd2
// `define FINISH 3'd7

module lenet_rtl_basic_dma64( clk, rst, dma_read_chnl_valid, dma_read_chnl_data, dma_read_chnl_ready,
/* <<--params-list-->> */
conf_info_scale_CONV2,
conf_info_scale_CONV3,
conf_info_scale_CONV1,
conf_info_scale_FC2,
conf_info_scale_FC1,
conf_done, acc_done, debug, dma_read_ctrl_valid, dma_read_ctrl_data_index, dma_read_ctrl_data_length, dma_read_ctrl_data_size, dma_read_ctrl_ready, dma_write_ctrl_valid, dma_write_ctrl_data_index, dma_write_ctrl_data_length, dma_write_ctrl_data_size, dma_write_ctrl_ready, dma_write_chnl_valid, dma_write_chnl_data, dma_write_chnl_ready);

   input clk;
   input rst;

   /* <<--params-def-->> */
   input wire [31:0]  conf_info_scale_CONV2;
   input wire [31:0]  conf_info_scale_CONV3;
   input wire [31:0]  conf_info_scale_CONV1;
   input wire [31:0]  conf_info_scale_FC2;
   input wire [31:0]  conf_info_scale_FC1;
   input wire 	       conf_done;

   input wire 	       dma_read_ctrl_ready;
   output reg	       dma_read_ctrl_valid;
   output reg [31:0]  dma_read_ctrl_data_index;
   output reg [31:0]  dma_read_ctrl_data_length;
   output reg [ 2:0]  dma_read_ctrl_data_size;

   output reg	       dma_read_chnl_ready;
   input wire 	       dma_read_chnl_valid;
   input wire [63:0]  dma_read_chnl_data;

   input wire         dma_write_ctrl_ready;
   output reg	       dma_write_ctrl_valid;
   output reg [31:0]  dma_write_ctrl_data_index;
   output reg [31:0]  dma_write_ctrl_data_length;
   output reg [ 2:0]  dma_write_ctrl_data_size;

   input wire 	       dma_write_chnl_ready;
   output reg	       dma_write_chnl_valid;
   output reg [63:0]  dma_write_chnl_data;

   output reg     	 acc_done;
   output reg [31:0]  debug;
   
   ///////////////////////////////////
   // Add your design here
   reg [2:0] state, next_state;
   wire read_done, write_done;

   // weight
   wire [3:0] weight_wea0, weight_wea1;
   wire [15:0] weight_addr0, weight_addr1;
   wire [31:0] weight_wdata0, weight_wdata1;
   wire [31:0] weight_rdata0, weight_rdata1;

   // act
   wire [3:0] act_wea0, act_wea1;
   reg [15:0] act_addr0, act_addr1;
   wire [15:0] read_act_addr0, write_act_addr0, read_act_addr1, write_act_addr1;
   wire [31:0] act_wdata0, act_wdata1;
   wire [31:0] act_rdata0, act_rdata1;


   SRAM_weight_16384x32b sram_weight ( 
      .clk(clk),
      .wea0(weight_wea0),
      .addr0(weight_addr0),
      .wdata0(weight_wdata0),
      .rdata0(weight_rdata0),
      .wea1(weight_wea1),
      .addr1(weight_addr1),
      .wdata1(weight_wdata1),
      .rdata1(weight_rdata1)
   );

   SRAM_activation_1024x32b sram_act ( 
      .clk(clk),
      .wea0(act_wea0),
      .addr0(act_addr0),
      .wdata0(act_wdata0),
      .rdata0(act_rdata0),
      .wea1(act_wea1),
      .addr1(act_addr1),
      .wdata1(act_wdata1),
      .rdata1(act_rdata1)
   );

   dma_read dr(
      .clk(clk),
      .rst(rst),
      .do_read(state == `READ),
      .read_done(read_done),

      .dma_read_ctrl_ready(dma_read_ctrl_ready),
      .dma_read_ctrl_valid(dma_read_ctrl_valid),
      .dma_read_ctrl_data_index(dma_read_ctrl_data_index),
      .dma_read_ctrl_data_length(dma_read_ctrl_data_length),
      .dma_read_ctrl_data_size(dma_read_ctrl_data_size),
      .dma_read_chnl_ready(dma_read_chnl_ready),
      .dma_read_chnl_valid(dma_read_chnl_valid),
      .dma_read_chnl_data(dma_read_chnl_data),

      .weight_wea0(weight_wea0), .weight_wea1(weight_wea1),
      .weight_addr0(weight_addr0), .weight_addr1(weight_addr1),
      .weight_wdata0(weight_wdata0), .weight_wdata1(weight_wdata1),

      .act_wea0(act_wea0), .act_wea1(act_wea1),
      .act_addr0(read_act_addr0), .act_addr1(read_act_addr1),
      .act_wdata0(act_wdata0), .act_wdata1(act_wdata1)
   );

   dma_write dw(
      .clk(clk),
      .rst(rst),
      .do_write(state == `WRITE),
      .write_done(write_done),

      .dma_write_ctrl_ready(dma_write_ctrl_ready),
      .dma_write_ctrl_valid(dma_write_ctrl_valid),
      .dma_write_ctrl_data_index(dma_write_ctrl_data_index),
      .dma_write_ctrl_data_length(dma_write_ctrl_data_length),
      .dma_write_ctrl_data_size(dma_write_ctrl_data_size),
      .dma_write_chnl_ready(dma_write_chnl_ready),
      .dma_write_chnl_valid(dma_write_chnl_valid),
      .dma_write_chnl_data(dma_write_chnl_data),
      

      .act_rdata0(act_rdata0), .act_rdata1(act_rdata1),
      .act_addr0(write_act_addr0), .act_addr1(write_act_addr1)
   );

   // debug //////////////////////////////////////
   // dma_read
   /*wire [15:0] weight_addr0, act_addr0;
   assign weight_addr0 = dr.weight_addr0;
   assign act_addr0 = dr.act_addr0;

   wire [3:0] weight_wea0, act_wea0;
   assign weight_wea0 = dr.weight_wea0;
   assign act_wea0 = dr.act_wea0;

   wire [31:0] weight_wdata0, act_wdata0;
   assign weight_wdata0 = dr.weight_wdata0;
   assign act_wdata0 = dr.act_wdata0;

   // dma_write
   wire [15:0] act_addr0_dw;
   assign act_addr0_dw = dw.act_addr0;

   wire [31:0] act_rdata0;
   assign act_rdata0 = dw.act_rdata0;*/
   ////////////////////////////////////////////////

   // FSM
   always @(posedge clk) begin
      if(!rst) begin
         state <= `WAIT;
      end
      else begin
         state <= next_state;
      end
   end

   always @(*) begin
      case(state)
         `WAIT: next_state = conf_done? `READ: `WAIT;
         `READ: next_state = read_done? `LENET: `READ;
         `LENET: next_state = `WRITE;
         `WRITE: next_state = write_done? `DONE: `WRITE;
         `DONE: next_state = `WAIT;
         default: next_state = state;
      endcase

      case(state)
         `DONE: acc_done = 1;
         default: acc_done = 0;
      endcase

      case(state)
         `READ: begin
            act_addr0 = read_act_addr0;
            act_addr1 = read_act_addr1;
         end
         default: begin
            act_addr0 = write_act_addr0;
            act_addr1 = write_act_addr1;
         end
      endcase
   end
   
endmodule

//

module dma_read(
   input wire clk,
   input wire rst,
   input wire do_read,
   output reg read_done,

   input wire dma_read_ctrl_ready,
   output reg dma_read_ctrl_valid,
   output reg [31:0] dma_read_ctrl_data_index,
   output reg [31:0] dma_read_ctrl_data_length,
   output reg [2:0] dma_read_ctrl_data_size,
   output reg dma_read_chnl_ready,
   input wire dma_read_chnl_valid,
   input wire [63:0] dma_read_chnl_data,

   output reg [3:0] weight_wea0, weight_wea1,
   output reg [15:0] weight_addr0, weight_addr1,
   output reg [31:0] weight_wdata0, weight_wdata1,

   output reg [3:0] act_wea0, act_wea1,
   output reg [15:0] act_addr0, act_addr1,
   output reg [31:0] act_wdata0, act_wdata1
);

   reg [2:0] state, next_state;
   reg next_dma_read_ctrl_valid;
   reg [31:0] next_dma_read_ctrl_data_index;
   reg [31:0] next_dma_read_ctrl_data_length;
   reg [2:0] next_dma_read_ctrl_data_size;
   reg next_dma_read_chnl_ready;
   reg next_read_done;

   // weight
   reg [3:0] next_weight_wea0, next_weight_wea1;
   reg [15:0] next_weight_addr0, next_weight_addr1;
   reg [31:0] next_weight_wdata0, next_weight_wdata1;

   // act
   reg [3:0] next_act_wea0, next_act_wea1;
   reg [15:0] next_act_addr0, next_act_addr1;
   reg [31:0] next_act_wdata0, next_act_wdata1;

   always @(posedge clk) begin
      if(!rst) begin
         state <= `WAIT;
         read_done <= 0;

         dma_read_ctrl_valid <= 0;
         dma_read_ctrl_data_index <= 0;
         dma_read_ctrl_data_length <= 0;
         dma_read_ctrl_data_size <= 0;
         dma_read_chnl_ready <= 0;
         
         weight_wea0 <= 0;
         weight_wea1 <= 0;
         weight_addr0 <= 0;
         weight_addr1 <= 0;
         weight_wdata0 <= 0;
         weight_wdata1 <= 0;

         act_wea0 <= 0;
         act_wea1 <= 0;
         act_addr0 <= 0;
         act_addr1 <= 0;
         act_wdata0 <= 0;
         act_wdata1 <= 0;
      end
      else begin
         state <= next_state;
         read_done <= next_read_done;

         dma_read_ctrl_valid <= next_dma_read_ctrl_valid;
         dma_read_ctrl_data_index <= next_dma_read_ctrl_data_index;
         dma_read_ctrl_data_length <= next_dma_read_ctrl_data_length;
         dma_read_ctrl_data_size <= next_dma_read_ctrl_data_size;
         dma_read_chnl_ready <= next_dma_read_chnl_ready;
         
         weight_wea0 <= next_weight_wea0;
         weight_wea1 <= next_weight_wea1;
         weight_addr0 <= next_weight_addr0;
         weight_addr1 <= next_weight_addr1;
         weight_wdata0 <= next_weight_wdata0;
         weight_wdata1 <= next_weight_wdata1;

         act_wea0 <= next_act_wea0;
         act_wea1 <= next_act_wea1;
         act_addr0 <= next_act_addr0;
         act_addr1 <= next_act_addr1;
         act_wdata0 <= next_act_wdata0;
         act_wdata1 <= next_act_wdata1;
      end
   end

   always @(*) begin
      case(state)
         `WAIT: next_state = do_read? `WEIGHT_CTRL_S: `WAIT;
         `WEIGHT_CTRL_S: next_state = `WEIGHT_CTRL_R;
         `WEIGHT_CTRL_R: next_state = dma_read_ctrl_ready? `WEIGHT_CHNL: `WEIGHT_CTRL_R;
         `WEIGHT_CHNL: next_state = (weight_addr0 == 15758)? `ACT_CTRL_S: `WEIGHT_CHNL;
         `ACT_CTRL_S: next_state = `ACT_CTRL_R;
         `ACT_CTRL_R: next_state = dma_read_ctrl_ready? `ACT_CHNL: `ACT_CTRL_R;
         `ACT_CHNL: next_state = (act_addr0 == 254)? `FINISH: `ACT_CHNL;
         default: next_state = `FINISH; // `FINISH
      endcase

      case(state) 
         `FINISH: next_read_done = 1'b1;
         default: next_read_done = 1'b0;
      endcase
   end

   always @(*) begin
      next_dma_read_ctrl_valid = 0;
      next_dma_read_ctrl_data_index = 0;
      next_dma_read_ctrl_data_length = 0;
      next_dma_read_ctrl_data_size = 0;
      next_dma_read_chnl_ready = 0;
      
      next_weight_wea0 = 0;
      next_weight_wea1 = 0;
      next_weight_addr0 = weight_addr0;
      next_weight_addr1 = weight_addr1;
      next_weight_wdata0 = 0;
      next_weight_wdata1 = 0;

      next_act_wea0 = 0;
      next_act_wea1 = 0;
      next_act_addr0 = act_addr0;
      next_act_addr1 = act_addr1;
      next_act_wdata0 = 0;
      next_act_wdata1 = 0;

      case(state)
         `WEIGHT_CTRL_S: begin
            next_dma_read_ctrl_valid = 1;
            next_dma_read_ctrl_data_index = 0;
            next_dma_read_ctrl_data_length = 7880;
            next_dma_read_ctrl_data_size = 3'b010;

            next_weight_addr0 = 0-2;
            next_weight_addr1 = 1-2;
         end
         `WEIGHT_CTRL_R: begin
            if(dma_read_ctrl_ready) begin
               next_dma_read_chnl_ready = 1;   
            end
            else begin
               next_dma_read_ctrl_valid = 1;
               next_dma_read_ctrl_data_index = 0;
               next_dma_read_ctrl_data_length = 7880;
               next_dma_read_ctrl_data_size = 3'b010;
            end
         end
         `WEIGHT_CHNL: begin   
            next_dma_read_chnl_ready = 1;

            if(dma_read_chnl_valid) begin  // to SRAM
               next_weight_wea0 = 4'b1111;
               next_weight_wea1 = 4'b1111;
               next_weight_addr0 = weight_addr0 + 2;
               next_weight_addr1 = weight_addr1 + 2;
               next_weight_wdata0 = dma_read_chnl_data[31:0];
               next_weight_wdata1 = dma_read_chnl_data[63:32];
            end
         end
         `ACT_CTRL_S: begin
            next_dma_read_ctrl_valid = 1;
            next_dma_read_ctrl_data_index = 10000;
            next_dma_read_ctrl_data_length = 128;
            next_dma_read_ctrl_data_size = 3'b010;

            next_act_addr0 = 0-2;
            next_act_addr1 = 1-2;
         end
         `ACT_CTRL_R: begin
            if(dma_read_ctrl_ready) begin
               next_dma_read_chnl_ready = 1;
            end
            else begin
               next_dma_read_ctrl_valid = 1;
               next_dma_read_ctrl_data_index = 10000;
               next_dma_read_ctrl_data_length = 128;
               next_dma_read_ctrl_data_size = 3'b010;
            end
         end
         `ACT_CHNL: begin   
            next_dma_read_chnl_ready = 1;

            if(dma_read_chnl_valid) begin  // to SRAM
               next_act_wea0 = 4'b1111;
               next_act_wea1 = 4'b1111;
               next_act_addr0 = act_addr0 + 2;
               next_act_addr1 = act_addr1 + 2;
               next_act_wdata0 = dma_read_chnl_data[31:0];
               next_act_wdata1 = dma_read_chnl_data[63:32];
            end
         end
      endcase
   end

endmodule

//

module dma_write(
   input wire clk,
   input wire rst,
   input wire do_write,
   output reg write_done,

   input wire dma_write_ctrl_ready,
   output reg dma_write_ctrl_valid,
   output reg [31:0] dma_write_ctrl_data_index,
   output reg [31:0] dma_write_ctrl_data_length,
   output reg [2:0] dma_write_ctrl_data_size,
   input wire dma_write_chnl_ready,
   output reg dma_write_chnl_valid,
   output reg [63:0] dma_write_chnl_data,

   input wire [31:0] act_rdata0, act_rdata1,
   output reg [15:0] act_addr0, act_addr1
);

   reg [2:0] state, next_state;
   reg next_dma_write_ctrl_valid;
   reg [31:0] next_dma_write_ctrl_data_index;
   reg [31:0] next_dma_write_ctrl_data_length;
   reg [2:0] next_dma_write_ctrl_data_size;
   reg next_dma_write_chnl_valid;
   reg [63:0] next_dma_write_chnl_data;
   reg next_write_done;

   // act
   reg [15:0] next_act_addr0, next_act_addr1;

   always @(posedge clk) begin
      if(!rst) begin
         state <= `WAIT;
         write_done <= 0;

         dma_write_ctrl_valid <= 0;
         dma_write_ctrl_data_index <= 0;
         dma_write_ctrl_data_length <= 0;
         dma_write_ctrl_data_size <= 0;
         dma_write_chnl_valid <= 0;
         dma_write_chnl_data <= 0;

         act_addr0 <= 0;
         act_addr1 <= 0;
      end
      else begin
         state <= next_state;
         write_done <= next_write_done;

         dma_write_ctrl_valid <= next_dma_write_ctrl_valid;
         dma_write_ctrl_data_index <= next_dma_write_ctrl_data_index;
         dma_write_ctrl_data_length <= next_dma_write_ctrl_data_length;
         dma_write_ctrl_data_size <= next_dma_write_ctrl_data_size;
         dma_write_chnl_valid <= next_dma_write_chnl_valid;
         dma_write_chnl_data <= next_dma_write_chnl_data;

         act_addr0 <= next_act_addr0;
         act_addr1 <= next_act_addr1;
      end
   end

   always @(*) begin
      case(state)
         `WAIT: next_state = do_write? `ACT_CTRL_S: `WAIT;
         `ACT_CTRL_S: next_state = `ACT_CTRL_R;
         `ACT_CTRL_R: next_state = dma_write_ctrl_ready? `ACT_CHNL_S: `ACT_CTRL_R;
         `ACT_CHNL_S: next_state = `ACT_CHNL_R;
         `ACT_CHNL_R: begin
            if(dma_write_chnl_ready) 
               next_state = (act_addr0 == 752)? `FINISH: `ACT_CHNL_S;
            else
               next_state = `ACT_CHNL_R;
         end
         default: next_state = `FINISH; // `FINISH
      endcase

      case(state) 
         `FINISH: next_write_done = 1'b1;
         default: next_write_done = 1'b0;
      endcase
   end

   always @(*) begin
      next_dma_write_ctrl_valid = 0;
      next_dma_write_ctrl_data_index = 0;
      next_dma_write_ctrl_data_length = 0;
      next_dma_write_ctrl_data_size = 0;
      next_dma_write_chnl_valid = 0;
      next_dma_write_chnl_data = 0;

      next_act_addr0 = act_addr0;
      next_act_addr1 = act_addr1;

      case(state)
         `ACT_CTRL_S: begin
            next_dma_write_ctrl_valid = 1;
            next_dma_write_ctrl_data_index = 10000;
            next_dma_write_ctrl_data_length = 376;
            next_dma_write_ctrl_data_size = 3'b010;

            next_act_addr0 = 0;
            next_act_addr1 = 1;
         end
         `ACT_CTRL_R: begin
            if(!dma_write_ctrl_ready) begin
               next_dma_write_ctrl_valid = 1;
               next_dma_write_ctrl_data_index = 10000;
               next_dma_write_ctrl_data_length = 376;
               next_dma_write_ctrl_data_size = 3'b010;
            end
         end
         `ACT_CHNL_S: begin   
            next_dma_write_chnl_valid = 1;
            next_dma_write_chnl_data = {act_rdata1, act_rdata0};

            next_act_addr0 = act_addr0 + 2;
            next_act_addr1 = act_addr1 + 2;
         end
         `ACT_CHNL_R: begin
            if(!dma_write_chnl_ready) begin // wait for ready
               next_dma_write_chnl_valid = 1;
               next_dma_write_chnl_data = dma_write_chnl_data;
            end
         end
      endcase
   end

endmodule