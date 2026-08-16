`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 18:16:32
// Design Name: 
// Module Name: point_move_lock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module point_move_lock(
    input clk,
    input [767:0] adc_data_in,
    input [6:0] max_addr,
    input cross_correlation_finish,
    input [1:0] addr_bias_flag,//0 max_addr; 1 pre; 2 now; 3 delay;£¨for signal£©
    output reg [6:0] real_addr,
    output reg adc_data_out_valid,
    output reg [767:0] adc_data_out,
    input addr_set_flag,
    input [6:0] addr_set_value
    );
localparam ADC_WIDTH = 3'd6;
reg [2:0] adc_data_acq_index;
reg [767:0] adc_data_in_slice[0:7];
reg [767:0] adc_data_acq,adc_data_acq_f1;

always @(posedge clk) begin
    if(addr_set_flag) real_addr <= addr_set_value;
    else if(addr_bias_flag == 2'd1) real_addr <= real_addr - 1'b1;
    else if(addr_bias_flag == 2'd2) real_addr <= real_addr;
    else if(addr_bias_flag == 2'd3) real_addr <= real_addr + 1'b1;
    else real_addr <= max_addr;
end
always @(posedge clk) begin
    if(addr_bias_flag != 2'd0) begin
        if(real_addr == 7'd127 && addr_bias_flag == 2'd3) begin
            adc_data_acq_index <= adc_data_acq_index - 1'b1;
        end
        else if(real_addr == 7'd0 && addr_bias_flag == 2'd1) begin
            adc_data_acq_index <= adc_data_acq_index + 1'b1;
        end
    end
    else adc_data_acq_index <= 3'd3;
end
always @(posedge clk) begin
    case(adc_data_acq_index)
    3'd0: adc_data_acq <= adc_data_in_slice[0];
    3'd1: adc_data_acq <= adc_data_in_slice[1];
    3'd2: adc_data_acq <= adc_data_in_slice[2];
    3'd3: adc_data_acq <= adc_data_in_slice[3];
    3'd4: adc_data_acq <= adc_data_in_slice[4];
    3'd5: adc_data_acq <= adc_data_in_slice[5];
    3'd6: adc_data_acq <= adc_data_in_slice[6];
    3'd7: adc_data_acq <= adc_data_in_slice[7];
    endcase
end
always @(posedge clk) begin
    adc_data_in_slice[0] <= adc_data_in;
    adc_data_in_slice[1] <= adc_data_in_slice[0];
    adc_data_in_slice[2] <= adc_data_in_slice[1];
    adc_data_in_slice[3] <= adc_data_in_slice[2];
    adc_data_in_slice[4] <= adc_data_in_slice[3];
    adc_data_in_slice[5] <= adc_data_in_slice[4];
    adc_data_in_slice[6] <= adc_data_in_slice[5];
    adc_data_in_slice[7] <= adc_data_in_slice[6];
    adc_data_acq_f1 <= adc_data_acq;
    adc_data_out_valid <= cross_correlation_finish;
end
always @(posedge clk) begin
    case(real_addr) //move to new data
    7'd0: adc_data_out <= adc_data_acq_f1;//¿¼ÂÇÊÇadc_data_acq»¹ÊÇadc_data_acq_f1
    7'd1: adc_data_out <= {adc_data_acq[ADC_WIDTH*1-1:0],adc_data_acq_f1[767:ADC_WIDTH*1]};
    7'd2: adc_data_out <= {adc_data_acq[ADC_WIDTH*2-1:0],adc_data_acq_f1[767:ADC_WIDTH*2]};
    7'd3: adc_data_out <= {adc_data_acq[ADC_WIDTH*3-1:0],adc_data_acq_f1[767:ADC_WIDTH*3]};
    7'd4: adc_data_out <= {adc_data_acq[ADC_WIDTH*4-1:0],adc_data_acq_f1[767:ADC_WIDTH*4]};
    7'd5: adc_data_out <= {adc_data_acq[ADC_WIDTH*5-1:0],adc_data_acq_f1[767:ADC_WIDTH*5]};
    7'd6: adc_data_out <= {adc_data_acq[ADC_WIDTH*6-1:0],adc_data_acq_f1[767:ADC_WIDTH*6]};
    7'd7: adc_data_out <= {adc_data_acq[ADC_WIDTH*7-1:0],adc_data_acq_f1[767:ADC_WIDTH*7]};
    7'd8: adc_data_out <= {adc_data_acq[ADC_WIDTH*8-1:0],adc_data_acq_f1[767:ADC_WIDTH*8]};
    7'd9: adc_data_out <= {adc_data_acq[ADC_WIDTH*9-1:0],adc_data_acq_f1[767:ADC_WIDTH*9]};
    7'd10: adc_data_out <= {adc_data_acq[ADC_WIDTH*10-1:0],adc_data_acq_f1[767:ADC_WIDTH*10]};
    7'd11: adc_data_out <= {adc_data_acq[ADC_WIDTH*11-1:0],adc_data_acq_f1[767:ADC_WIDTH*11]};
    7'd12: adc_data_out <= {adc_data_acq[ADC_WIDTH*12-1:0],adc_data_acq_f1[767:ADC_WIDTH*12]};
    7'd13: adc_data_out <= {adc_data_acq[ADC_WIDTH*13-1:0],adc_data_acq_f1[767:ADC_WIDTH*13]};
    7'd14: adc_data_out <= {adc_data_acq[ADC_WIDTH*14-1:0],adc_data_acq_f1[767:ADC_WIDTH*14]};
    7'd15: adc_data_out <= {adc_data_acq[ADC_WIDTH*15-1:0],adc_data_acq_f1[767:ADC_WIDTH*15]};
    7'd16: adc_data_out <= {adc_data_acq[ADC_WIDTH*16-1:0],adc_data_acq_f1[767:ADC_WIDTH*16]};
    7'd17: adc_data_out <= {adc_data_acq[ADC_WIDTH*17-1:0],adc_data_acq_f1[767:ADC_WIDTH*17]};
    7'd18: adc_data_out <= {adc_data_acq[ADC_WIDTH*18-1:0],adc_data_acq_f1[767:ADC_WIDTH*18]};
    7'd19: adc_data_out <= {adc_data_acq[ADC_WIDTH*19-1:0],adc_data_acq_f1[767:ADC_WIDTH*19]};
    7'd20: adc_data_out <= {adc_data_acq[ADC_WIDTH*20-1:0],adc_data_acq_f1[767:ADC_WIDTH*20]};
    7'd21: adc_data_out <= {adc_data_acq[ADC_WIDTH*21-1:0],adc_data_acq_f1[767:ADC_WIDTH*21]};
    7'd22: adc_data_out <= {adc_data_acq[ADC_WIDTH*22-1:0],adc_data_acq_f1[767:ADC_WIDTH*22]};
    7'd23: adc_data_out <= {adc_data_acq[ADC_WIDTH*23-1:0],adc_data_acq_f1[767:ADC_WIDTH*23]};
    7'd24: adc_data_out <= {adc_data_acq[ADC_WIDTH*24-1:0],adc_data_acq_f1[767:ADC_WIDTH*24]};
    7'd25: adc_data_out <= {adc_data_acq[ADC_WIDTH*25-1:0],adc_data_acq_f1[767:ADC_WIDTH*25]};
    7'd26: adc_data_out <= {adc_data_acq[ADC_WIDTH*26-1:0],adc_data_acq_f1[767:ADC_WIDTH*26]};
    7'd27: adc_data_out <= {adc_data_acq[ADC_WIDTH*27-1:0],adc_data_acq_f1[767:ADC_WIDTH*27]};
    7'd28: adc_data_out <= {adc_data_acq[ADC_WIDTH*28-1:0],adc_data_acq_f1[767:ADC_WIDTH*28]};
    7'd29: adc_data_out <= {adc_data_acq[ADC_WIDTH*29-1:0],adc_data_acq_f1[767:ADC_WIDTH*29]};
    7'd30: adc_data_out <= {adc_data_acq[ADC_WIDTH*30-1:0],adc_data_acq_f1[767:ADC_WIDTH*30]};
    7'd31: adc_data_out <= {adc_data_acq[ADC_WIDTH*31-1:0],adc_data_acq_f1[767:ADC_WIDTH*31]};
    7'd32: adc_data_out <= {adc_data_acq[ADC_WIDTH*32-1:0],adc_data_acq_f1[767:ADC_WIDTH*32]};
    7'd33: adc_data_out <= {adc_data_acq[ADC_WIDTH*33-1:0],adc_data_acq_f1[767:ADC_WIDTH*33]};
    7'd34: adc_data_out <= {adc_data_acq[ADC_WIDTH*34-1:0],adc_data_acq_f1[767:ADC_WIDTH*34]};
    7'd35: adc_data_out <= {adc_data_acq[ADC_WIDTH*35-1:0],adc_data_acq_f1[767:ADC_WIDTH*35]};
    7'd36: adc_data_out <= {adc_data_acq[ADC_WIDTH*36-1:0],adc_data_acq_f1[767:ADC_WIDTH*36]};
    7'd37: adc_data_out <= {adc_data_acq[ADC_WIDTH*37-1:0],adc_data_acq_f1[767:ADC_WIDTH*37]};
    7'd38: adc_data_out <= {adc_data_acq[ADC_WIDTH*38-1:0],adc_data_acq_f1[767:ADC_WIDTH*38]};
    7'd39: adc_data_out <= {adc_data_acq[ADC_WIDTH*39-1:0],adc_data_acq_f1[767:ADC_WIDTH*39]};
    7'd40: adc_data_out <= {adc_data_acq[ADC_WIDTH*40-1:0],adc_data_acq_f1[767:ADC_WIDTH*40]};
    7'd41: adc_data_out <= {adc_data_acq[ADC_WIDTH*41-1:0],adc_data_acq_f1[767:ADC_WIDTH*41]};
    7'd42: adc_data_out <= {adc_data_acq[ADC_WIDTH*42-1:0],adc_data_acq_f1[767:ADC_WIDTH*42]};
    7'd43: adc_data_out <= {adc_data_acq[ADC_WIDTH*43-1:0],adc_data_acq_f1[767:ADC_WIDTH*43]};
    7'd44: adc_data_out <= {adc_data_acq[ADC_WIDTH*44-1:0],adc_data_acq_f1[767:ADC_WIDTH*44]};
    7'd45: adc_data_out <= {adc_data_acq[ADC_WIDTH*45-1:0],adc_data_acq_f1[767:ADC_WIDTH*45]};
    7'd46: adc_data_out <= {adc_data_acq[ADC_WIDTH*46-1:0],adc_data_acq_f1[767:ADC_WIDTH*46]};
    7'd47: adc_data_out <= {adc_data_acq[ADC_WIDTH*47-1:0],adc_data_acq_f1[767:ADC_WIDTH*47]};
    7'd48: adc_data_out <= {adc_data_acq[ADC_WIDTH*48-1:0],adc_data_acq_f1[767:ADC_WIDTH*48]};
    7'd49: adc_data_out <= {adc_data_acq[ADC_WIDTH*49-1:0],adc_data_acq_f1[767:ADC_WIDTH*49]};
    7'd50: adc_data_out <= {adc_data_acq[ADC_WIDTH*50-1:0],adc_data_acq_f1[767:ADC_WIDTH*50]};
    7'd51: adc_data_out <= {adc_data_acq[ADC_WIDTH*51-1:0],adc_data_acq_f1[767:ADC_WIDTH*51]};
    7'd52: adc_data_out <= {adc_data_acq[ADC_WIDTH*52-1:0],adc_data_acq_f1[767:ADC_WIDTH*52]};
    7'd53: adc_data_out <= {adc_data_acq[ADC_WIDTH*53-1:0],adc_data_acq_f1[767:ADC_WIDTH*53]};
    7'd54: adc_data_out <= {adc_data_acq[ADC_WIDTH*54-1:0],adc_data_acq_f1[767:ADC_WIDTH*54]};
    7'd55: adc_data_out <= {adc_data_acq[ADC_WIDTH*55-1:0],adc_data_acq_f1[767:ADC_WIDTH*55]};
    7'd56: adc_data_out <= {adc_data_acq[ADC_WIDTH*56-1:0],adc_data_acq_f1[767:ADC_WIDTH*56]};
    7'd57: adc_data_out <= {adc_data_acq[ADC_WIDTH*57-1:0],adc_data_acq_f1[767:ADC_WIDTH*57]};
    7'd58: adc_data_out <= {adc_data_acq[ADC_WIDTH*58-1:0],adc_data_acq_f1[767:ADC_WIDTH*58]};
    7'd59: adc_data_out <= {adc_data_acq[ADC_WIDTH*59-1:0],adc_data_acq_f1[767:ADC_WIDTH*59]};
    7'd60: adc_data_out <= {adc_data_acq[ADC_WIDTH*60-1:0],adc_data_acq_f1[767:ADC_WIDTH*60]};
    7'd61: adc_data_out <= {adc_data_acq[ADC_WIDTH*61-1:0],adc_data_acq_f1[767:ADC_WIDTH*61]};
    7'd62: adc_data_out <= {adc_data_acq[ADC_WIDTH*62-1:0],adc_data_acq_f1[767:ADC_WIDTH*62]};
    7'd63: adc_data_out <= {adc_data_acq[ADC_WIDTH*63-1:0],adc_data_acq_f1[767:ADC_WIDTH*63]};
    7'd64: adc_data_out <= {adc_data_acq[ADC_WIDTH*64-1:0],adc_data_acq_f1[767:ADC_WIDTH*64]};
    7'd65: adc_data_out <= {adc_data_acq[ADC_WIDTH*65-1:0],adc_data_acq_f1[767:ADC_WIDTH*65]};
    7'd66: adc_data_out <= {adc_data_acq[ADC_WIDTH*66-1:0],adc_data_acq_f1[767:ADC_WIDTH*66]};
    7'd67: adc_data_out <= {adc_data_acq[ADC_WIDTH*67-1:0],adc_data_acq_f1[767:ADC_WIDTH*67]};
    7'd68: adc_data_out <= {adc_data_acq[ADC_WIDTH*68-1:0],adc_data_acq_f1[767:ADC_WIDTH*68]};
    7'd69: adc_data_out <= {adc_data_acq[ADC_WIDTH*69-1:0],adc_data_acq_f1[767:ADC_WIDTH*69]};
    7'd70: adc_data_out <= {adc_data_acq[ADC_WIDTH*70-1:0],adc_data_acq_f1[767:ADC_WIDTH*70]};
    7'd71: adc_data_out <= {adc_data_acq[ADC_WIDTH*71-1:0],adc_data_acq_f1[767:ADC_WIDTH*71]};
    7'd72: adc_data_out <= {adc_data_acq[ADC_WIDTH*72-1:0],adc_data_acq_f1[767:ADC_WIDTH*72]};
    7'd73: adc_data_out <= {adc_data_acq[ADC_WIDTH*73-1:0],adc_data_acq_f1[767:ADC_WIDTH*73]};
    7'd74: adc_data_out <= {adc_data_acq[ADC_WIDTH*74-1:0],adc_data_acq_f1[767:ADC_WIDTH*74]};
    7'd75: adc_data_out <= {adc_data_acq[ADC_WIDTH*75-1:0],adc_data_acq_f1[767:ADC_WIDTH*75]};
    7'd76: adc_data_out <= {adc_data_acq[ADC_WIDTH*76-1:0],adc_data_acq_f1[767:ADC_WIDTH*76]};
    7'd77: adc_data_out <= {adc_data_acq[ADC_WIDTH*77-1:0],adc_data_acq_f1[767:ADC_WIDTH*77]};
    7'd78: adc_data_out <= {adc_data_acq[ADC_WIDTH*78-1:0],adc_data_acq_f1[767:ADC_WIDTH*78]};
    7'd79: adc_data_out <= {adc_data_acq[ADC_WIDTH*79-1:0],adc_data_acq_f1[767:ADC_WIDTH*79]};
    7'd80: adc_data_out <= {adc_data_acq[ADC_WIDTH*80-1:0],adc_data_acq_f1[767:ADC_WIDTH*80]};
    7'd81: adc_data_out <= {adc_data_acq[ADC_WIDTH*81-1:0],adc_data_acq_f1[767:ADC_WIDTH*81]};
    7'd82: adc_data_out <= {adc_data_acq[ADC_WIDTH*82-1:0],adc_data_acq_f1[767:ADC_WIDTH*82]};
    7'd83: adc_data_out <= {adc_data_acq[ADC_WIDTH*83-1:0],adc_data_acq_f1[767:ADC_WIDTH*83]};
    7'd84: adc_data_out <= {adc_data_acq[ADC_WIDTH*84-1:0],adc_data_acq_f1[767:ADC_WIDTH*84]};
    7'd85: adc_data_out <= {adc_data_acq[ADC_WIDTH*85-1:0],adc_data_acq_f1[767:ADC_WIDTH*85]};
    7'd86: adc_data_out <= {adc_data_acq[ADC_WIDTH*86-1:0],adc_data_acq_f1[767:ADC_WIDTH*86]};
    7'd87: adc_data_out <= {adc_data_acq[ADC_WIDTH*87-1:0],adc_data_acq_f1[767:ADC_WIDTH*87]};
    7'd88: adc_data_out <= {adc_data_acq[ADC_WIDTH*88-1:0],adc_data_acq_f1[767:ADC_WIDTH*88]};
    7'd89: adc_data_out <= {adc_data_acq[ADC_WIDTH*89-1:0],adc_data_acq_f1[767:ADC_WIDTH*89]};
    7'd90: adc_data_out <= {adc_data_acq[ADC_WIDTH*90-1:0],adc_data_acq_f1[767:ADC_WIDTH*90]};
    7'd91: adc_data_out <= {adc_data_acq[ADC_WIDTH*91-1:0],adc_data_acq_f1[767:ADC_WIDTH*91]};
    7'd92: adc_data_out <= {adc_data_acq[ADC_WIDTH*92-1:0],adc_data_acq_f1[767:ADC_WIDTH*92]};
    7'd93: adc_data_out <= {adc_data_acq[ADC_WIDTH*93-1:0],adc_data_acq_f1[767:ADC_WIDTH*93]};
    7'd94: adc_data_out <= {adc_data_acq[ADC_WIDTH*94-1:0],adc_data_acq_f1[767:ADC_WIDTH*94]};
    7'd95: adc_data_out <= {adc_data_acq[ADC_WIDTH*95-1:0],adc_data_acq_f1[767:ADC_WIDTH*95]};
    7'd96: adc_data_out <= {adc_data_acq[ADC_WIDTH*96-1:0],adc_data_acq_f1[767:ADC_WIDTH*96]};
    7'd97: adc_data_out <= {adc_data_acq[ADC_WIDTH*97-1:0],adc_data_acq_f1[767:ADC_WIDTH*97]};
    7'd98: adc_data_out <= {adc_data_acq[ADC_WIDTH*98-1:0],adc_data_acq_f1[767:ADC_WIDTH*98]};
    7'd99: adc_data_out <= {adc_data_acq[ADC_WIDTH*99-1:0],adc_data_acq_f1[767:ADC_WIDTH*99]};
    7'd100: adc_data_out <= {adc_data_acq[ADC_WIDTH*100-1:0],adc_data_acq_f1[767:ADC_WIDTH*100]};
    7'd101: adc_data_out <= {adc_data_acq[ADC_WIDTH*101-1:0],adc_data_acq_f1[767:ADC_WIDTH*101]};
    7'd102: adc_data_out <= {adc_data_acq[ADC_WIDTH*102-1:0],adc_data_acq_f1[767:ADC_WIDTH*102]};
    7'd103: adc_data_out <= {adc_data_acq[ADC_WIDTH*103-1:0],adc_data_acq_f1[767:ADC_WIDTH*103]};
    7'd104: adc_data_out <= {adc_data_acq[ADC_WIDTH*104-1:0],adc_data_acq_f1[767:ADC_WIDTH*104]};
    7'd105: adc_data_out <= {adc_data_acq[ADC_WIDTH*105-1:0],adc_data_acq_f1[767:ADC_WIDTH*105]};
    7'd106: adc_data_out <= {adc_data_acq[ADC_WIDTH*106-1:0],adc_data_acq_f1[767:ADC_WIDTH*106]};
    7'd107: adc_data_out <= {adc_data_acq[ADC_WIDTH*107-1:0],adc_data_acq_f1[767:ADC_WIDTH*107]};
    7'd108: adc_data_out <= {adc_data_acq[ADC_WIDTH*108-1:0],adc_data_acq_f1[767:ADC_WIDTH*108]};
    7'd109: adc_data_out <= {adc_data_acq[ADC_WIDTH*109-1:0],adc_data_acq_f1[767:ADC_WIDTH*109]};
    7'd110: adc_data_out <= {adc_data_acq[ADC_WIDTH*110-1:0],adc_data_acq_f1[767:ADC_WIDTH*110]};
    7'd111: adc_data_out <= {adc_data_acq[ADC_WIDTH*111-1:0],adc_data_acq_f1[767:ADC_WIDTH*111]};
    7'd112: adc_data_out <= {adc_data_acq[ADC_WIDTH*112-1:0],adc_data_acq_f1[767:ADC_WIDTH*112]};
    7'd113: adc_data_out <= {adc_data_acq[ADC_WIDTH*113-1:0],adc_data_acq_f1[767:ADC_WIDTH*113]};
    7'd114: adc_data_out <= {adc_data_acq[ADC_WIDTH*114-1:0],adc_data_acq_f1[767:ADC_WIDTH*114]};
    7'd115: adc_data_out <= {adc_data_acq[ADC_WIDTH*115-1:0],adc_data_acq_f1[767:ADC_WIDTH*115]};
    7'd116: adc_data_out <= {adc_data_acq[ADC_WIDTH*116-1:0],adc_data_acq_f1[767:ADC_WIDTH*116]};
    7'd117: adc_data_out <= {adc_data_acq[ADC_WIDTH*117-1:0],adc_data_acq_f1[767:ADC_WIDTH*117]};
    7'd118: adc_data_out <= {adc_data_acq[ADC_WIDTH*118-1:0],adc_data_acq_f1[767:ADC_WIDTH*118]};
    7'd119: adc_data_out <= {adc_data_acq[ADC_WIDTH*119-1:0],adc_data_acq_f1[767:ADC_WIDTH*119]};
    7'd120: adc_data_out <= {adc_data_acq[ADC_WIDTH*120-1:0],adc_data_acq_f1[767:ADC_WIDTH*120]};
    7'd121: adc_data_out <= {adc_data_acq[ADC_WIDTH*121-1:0],adc_data_acq_f1[767:ADC_WIDTH*121]};
    7'd122: adc_data_out <= {adc_data_acq[ADC_WIDTH*122-1:0],adc_data_acq_f1[767:ADC_WIDTH*122]};
    7'd123: adc_data_out <= {adc_data_acq[ADC_WIDTH*123-1:0],adc_data_acq_f1[767:ADC_WIDTH*123]};
    7'd124: adc_data_out <= {adc_data_acq[ADC_WIDTH*124-1:0],adc_data_acq_f1[767:ADC_WIDTH*124]};
    7'd125: adc_data_out <= {adc_data_acq[ADC_WIDTH*125-1:0],adc_data_acq_f1[767:ADC_WIDTH*125]};
    7'd126: adc_data_out <= {adc_data_acq[ADC_WIDTH*126-1:0],adc_data_acq_f1[767:ADC_WIDTH*126]};
    7'd127: adc_data_out <= {adc_data_acq[ADC_WIDTH*127-1:0],adc_data_acq_f1[767:ADC_WIDTH*127]};
    endcase
end
endmodule
