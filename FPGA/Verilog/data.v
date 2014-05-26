`include "define.v"
module data(
input wire CLK,
input wire RESET,
input wire START_BUFER,
input wire[`FSMC_WIDTH-1:0]CONTROL_REG,

output STOP_BUFER,
output RESET_CNT,
output BUFER_CHANGE,
output BUFER_EN,
output [`FSMC_WIDTH-1:0] DATA_OUT,
output [`DATA_READ_RAZR-1:0] BYTE_CNT
);


reg [2:0]state;
reg reset_cnt=1'b0;
reg bufer_change=1'b0;
reg bufer_en=1'b0;
reg [`FSMC_WIDTH-1:0] data_out;
reg [`DATA_READ_RAZR-1:0]	 byte_cnt=16'b0; //cnt number of data
reg [`FSMC_WIDTH-1:0]cnt;					//cnt for data and delay

assign BYTE_CNT=byte_cnt;
assign DATA_OUT=cnt[`FSMC_WIDTH-1:0];
assign RESET_CNT=reset_cnt;
assign BUFER_CHANGE=bufer_change;
assign BUFER_EN=bufer_en;
assign STOP_BUFER=(state==delay) ? 1'b1 : 1'b0;

parameter idle=0;
parameter start=1;
parameter work=2;
parameter work2=3;
parameter stop=4;
parameter delay=5;




always @(posedge CLK or posedge RESET or posedge START_BUFER)
begin
	if (RESET)
	begin
		state<=idle;
		byte_cnt<=16'b0;
		cnt=8'b0;
		bufer_change<=1'b0;
	end
	else if (START_BUFER)
	begin
		state<=start;
		
	end
	else
	begin
	
	case(state)
		idle:begin
		end
		start:begin
				state<=work;
				bufer_en<=1'b1;
				byte_cnt<=16'b0;
				cnt<=CONTROL_REG;
		end
		
		work:begin //mode write value in  memory
			if (byte_cnt<`LENTH_BUFER)begin
				byte_cnt<=byte_cnt+1'b1; 
				cnt<=cnt+1'b1;
			end	
			else state<=stop;
		end
		stop:begin
			
			state<=delay;
			bufer_en<=1'b0;
			cnt<=10;
		end
		delay:begin
			if (cnt==0) begin
				state<=idle;
				bufer_change=!bufer_change;
			end
			else cnt<=cnt-1'b1;
		end
		default:begin 
			state<=idle;
		end
		
	endcase	
		
	end
end

endmodule
