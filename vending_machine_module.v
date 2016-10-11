//  Damian G. Najera
//	EE 2169
//	Burrito Vending Machine
//	4/30/15

module vendingMachineFinal(clk, btn, sw, Rssd, Lssd, ld);
	input clk;
	input [3:0] btn;
	input [7:5] sw;
	output reg [6:0] Lssd;
	output reg [6:0] Rssd;
	output reg [7:0] ld;
	initial ld = 8'b00000000;
	reg [6:0] balance;
	initial balance = 0;
	reg [3:0] state, nxt_st;

	
	parameter reset= 0, 
				idle= 1, 
				dispenseBB= 2, 
				dispenseCB= 3,
				dispenseSB = 4, 
				addNickel = 5,
				addDime = 6,
				addQuarter = 7,
				error = 8;				
	
	always @ (posedge clk)
		begin 
			state = nxt_st;
			
			case (state)
				reset: begin //RESET
					balance = 0;
					nxt_st = idle;
				end
				
				idle: begin //IDLE
					ld = 8'b00000000;
					case (balance) 
						7'd0: begin Lssd = 7'b1111110; Rssd = 7'b1111110; end
						7'd5: begin Lssd = 7'b1111110; Rssd = 7'b1011011; end
						7'd10: begin Lssd = 7'b0110000; Rssd = 7'b1111110; end
						7'd15: begin Lssd = 7'b0110000; Rssd = 7'b1011011; end
						7'd20: begin Lssd = 7'b1101101; Rssd = 7'b1111110; end
						7'd25: begin Lssd = 7'b1101101; Rssd = 7'b1011011; end
						7'd30: begin Lssd = 7'b1111001; Rssd = 7'b1111110; end
						7'd35: begin Lssd = 7'b1111001; Rssd = 7'b1011011; end
						7'd40: begin Lssd = 7'b0110011; Rssd = 7'b1111110; end
						7'd45: begin Lssd = 7'b0110011; Rssd = 7'b1011011; end
						7'd50: begin Lssd = 7'b1011011; Rssd = 7'b1111110; end
						7'd55: begin Lssd = 7'b1011011; Rssd = 7'b1011011; end
						7'd60: begin Lssd = 7'b1011111; Rssd = 7'b1111110; end
						7'd65: begin Lssd = 7'b1011111; Rssd = 7'b1011011; end
						7'd70: begin Lssd = 7'b1110000; Rssd = 7'b1111110; end
						7'd75: begin Lssd = 7'b1110000; Rssd = 7'b1011011; end
						7'd80: begin Lssd = 7'b1111111; Rssd = 7'b1111110; end
						7'd85: begin Lssd = 7'b1111111; Rssd = 7'b1011011; end
						7'd90: begin Lssd = 7'b1111011; Rssd = 7'b1111110; end
						7'd95: begin Lssd = 7'b1111011; Rssd = 7'b1011011; end
						default begin Lssd = 7'b1111110; Rssd = 7'b1111110; end
					endcase
					
					if (balance >= 100) begin balance = balance - 100; end
					
					else if (sw[7]) begin
						if (balance >= 15) nxt_st = dispenseBB; 
						else nxt_st = error; 
					end
						
					else if (sw[6]) begin
						if (balance >= 50) nxt_st = dispenseCB; 
						else nxt_st = error;  
					end
						
					else if (sw[5]) begin
						if (balance >= 70) nxt_st = dispenseSB; 
						else nxt_st = error; 
					end
					else if (btn[3]) nxt_st = addNickel; 
					else if (btn[2]) nxt_st = addDime; 
					else if (btn[1]) nxt_st = addQuarter; 
					else if (btn[0]) nxt_st = reset; 
					else nxt_st = idle;
				end
					
				dispenseBB: begin
					ld = 8'b11111111;
					Lssd = 7'b1111111;
					Rssd = 7'b1111111;
					nxt_st = reset;
				end	
				
				dispenseCB: begin
					ld = 8'b11111111;
					Lssd = 7'b1001110;
					Rssd = 7'b1111111;
					nxt_st = reset;
				end
				
				dispenseSB: begin
					ld = 8'b11111111;
				   Lssd = 7'b1011011;
					Rssd = 7'b1111111;
					nxt_st = reset;
				end
				
				addNickel: begin
					balance = balance + 5;
					nxt_st = idle;
				end
				
				addDime: begin
					balance = balance + 10;
					nxt_st = idle;
				end
				
				addQuarter: begin
					balance = balance + 25;
					nxt_st = idle;
				end
				
				error: begin
				Lssd = 7'b1001111; 
				Rssd = 7'b1001111;
				nxt_st = idle; 
				end
				
				default: nxt_st = reset;
			endcase 
		end 
endmodule
