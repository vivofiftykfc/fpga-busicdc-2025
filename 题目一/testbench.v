`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/20 09:18:56
// Design Name: 
// Module Name: testbench
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


module testbench(
output reg  clk,
output reg rst_n,
output reg [63:0]tdata,
output reg [7:0]tkeep,
output reg tvalid,
input wire tready,
output reg tlast
    );
//---------------------------------------------------------------------------------------------------------------------
reg [19:0] frame_counter;
reg [10:0]  counter64_in_frame;

wire [47:0] dest_MAC_addr;
wire [47:0] src_MAC_addr;
wire [3:0] IP_Version;
wire [3:0] IP_Header_Length;
wire [7:0] IP_TOS;
wire [15:0] IP_Total_Length;
wire [15:0] IP_ID;
wire [15:0] IP_Flag_and_Fragment_Offset;
wire [15:0] IP_Flag_and_Fragment_Offset_1;
wire [15:0] IP_Flag_and_Fragment_Offset_2;
wire [15:0] IP_Flag_and_Fragment_Offset_3;
wire [7:0] IP_TTL;
wire [7:0] fourth_protocl;
wire [7:0] fourth_protocl_ESP;
wire [15:0] IP_Header_Checksum;
wire [31:0] SrcIP_1;
wire [31:0] DesIP_1;
wire [31:0] SPI_1;
wire [31:0] SrcIP_2;
wire [31:0] DesIP_2;
wire [31:0] SPI_2;
wire [15:0] Src_Port;
wire [15:0] Des_Port;
wire [127:0] TCP_Header;
wire [31:0] SPI;
wire [63:0] ICMP_Header;
wire [63:0] ICMP_Header_1;
wire [63:0] ICMP_Header_2;
wire [15:0] second_protocl;

  assign dest_MAC_addr =48'h010203040506;  
  assign src_MAC_addr =48'h010203040506;   
  assign second_protocl = 16'h0008;           
  assign IP_Version = 4'h4;              
  assign IP_Header_Length = 4'h5;           
  assign IP_TOS =8'b0;                  
  assign IP_Total_Length=16'h0030;         
  assign IP_ID=16'habcd;                   
  assign IP_Flag_and_Fragment_Offset=16'h0040;
  assign IP_Flag_and_Fragment_Offset_1=16'h0000;    
  assign IP_Flag_and_Fragment_Offset_2=16'h1000;     
  assign IP_Flag_and_Fragment_Offset_3=16'h1100;    
  assign IP_TTL=8'h00;          
  assign fourth_protocl_ESP=8'h32;          
  assign fourth_protocl=8'h01; 
         
  assign IP_Header_Checksum=16'h0000;   
  assign SrcIP_1 =32'hC801080a;          
  assign DesIP_1 =32'h6401080a;  
  assign ICMP_Header_1 =64'h5566778833442211;       
  assign SPI_1=32'h80808080;
  
  assign SrcIP_2 =32'h6401080a;           
  assign DesIP_2 =32'hC801080a;  
  assign ICMP_Header_2 =64'h5566778833442222;          
  assign SPI_2=32'h40404040;
 
  assign Src_Port =16'h0001;           
  assign Des_Port =16'h0203;            
  assign SPI =32'h11223344;            
  assign ICMP_Header =64'h5566778833442211;
  assign TCP_Header=128'b0;
  
  wire [6399:0] IP_TCP_1;
  wire [6399:0] IP_TCP_2;
  wire [6399:0] IP_TCP_3;
  wire [6399:0] IP_ICMP_1;
  wire [6399:0] IP_ICMP_2;
  wire [6399:0] IP_ICMP_3;
  wire [5887:0] TCP_data;
  reg [6399:0] send_data;
  
  
 assign TCP_data=5888'h00000000001111111111222222222233333333334444444444555555555566666666667777777777888888880000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888;
 assign IP_ICMP_1 = {TCP_data,176'b0,ICMP_Header_1,DesIP_1,SrcIP_1,IP_Header_Checksum,fourth_protocl,IP_TTL,IP_Flag_and_Fragment_Offset,IP_ID,IP_Total_Length,IP_TOS,IP_Version,IP_Header_Length,16'h0081,src_MAC_addr,dest_MAC_addr};
 assign IP_ICMP_2 = {TCP_data,176'b0,ICMP_Header_1,DesIP_1,SrcIP_1,IP_Header_Checksum,fourth_protocl,IP_TTL,IP_Flag_and_Fragment_Offset,IP_ID,IP_Total_Length,IP_TOS,IP_Version,IP_Header_Length,second_protocl,src_MAC_addr,dest_MAC_addr};
 assign IP_ICMP_3 = {TCP_data,176'b0,ICMP_Header_2,DesIP_2,SrcIP_2,IP_Header_Checksum,fourth_protocl,IP_TTL,IP_Flag_and_Fragment_Offset,IP_ID,IP_Total_Length,IP_TOS,IP_Version,IP_Header_Length,second_protocl,src_MAC_addr,dest_MAC_addr};
  
 
always @(posedge clk or negedge rst_n) 
if(!rst_n) begin
     tdata <= 64'b0;
     tkeep <= 8'b0;
     tvalid <= 1'b0;
     tlast <= 1'b0; 
     send_data <= 6400'b0;
end
else begin
    tkeep <= 8'hff;
    if(counter64_in_frame == 0)
         send_data <= IP_ICMP_1;          
    else if(((counter64_in_frame >=1) && (counter64_in_frame <= 100))||((counter64_in_frame >=103) && (counter64_in_frame <= 202))||((counter64_in_frame >=205) && (counter64_in_frame <= 304)) ) 
         send_data <= send_data >> 64;
    else if(counter64_in_frame == 102)
         send_data <= IP_ICMP_2; 
    else if(counter64_in_frame == 204)
         send_data <= IP_ICMP_3; 
     else 
         send_data <=  6400'b0;
         
    if(((counter64_in_frame >= 1) && (counter64_in_frame <= 100))||((counter64_in_frame >=103) && (counter64_in_frame <= 202))||((counter64_in_frame >=205) && (counter64_in_frame <= 304)) )
         tdata <= send_data[63:0];      
    else 
         tdata <= 64'b0;
     
      if(((counter64_in_frame >= 1) && (counter64_in_frame <= 100))||((counter64_in_frame >=103) && (counter64_in_frame <= 202))||((counter64_in_frame >=205) && (counter64_in_frame <= 304)) )
         tvalid <= 1'b1;
       else
         tvalid <= 1'b0; 
    
    if ((counter64_in_frame == 100)||(counter64_in_frame == 202)||(counter64_in_frame == 304))
         tlast <= 1'b1;
    else
         tlast <= 1'b0;      
end

always@(posedge clk or negedge rst_n) 
if(!rst_n) begin
    counter64_in_frame <= 11'b0;
end
else begin
    if(counter64_in_frame == 400) begin     
     counter64_in_frame <= counter64_in_frame;
      end
    else 
      counter64_in_frame <= counter64_in_frame +1;
end

//---------------------------------------------------------------------------------------------------------------------------------

initial
 begin
    clk <= 0;
    forever
    begin
       clk <= 0;
       #3.2;
        clk <= 1;
       #3.2;
    end
  end

initial
begin
  rst_n<=0;
 #50
  rst_n<=1;
 end
endmodule
