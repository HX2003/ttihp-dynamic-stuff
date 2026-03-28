/*
 * Copyright (c) 2026 HX2003
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_hx2003_dynamic_test (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_oe  = 8'b0;  // All bidirectional IOs are inputs
  assign uio_out = 8'b0;
  
  wire d0 = ui_in[0];
  wire d1 = ui_in[1];
  wire clka = ui_in[2];
  wire clkb = ui_in[3];
  
  assign uo_out = {6'b0, q1_buffered, q0_buffered};
  
  wire A0, A1, A2;
  wire B0, B1, B2;
  wire Q0, Q1;
  wire q0_buffered, q1_buffered;
 	
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf0( .A(clka), .Y(A0) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf1( .A(clka), .Y(A1) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf2( .A(clka), .Y(A2) );
  
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf3( .A(clkb), .Y(B0) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf4( .A(clkb), .Y(B1) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf5( .A(clkb), .Y(B2) );

  
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf6( .A(d0), .Y(D0_BUFFERED) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf7( .A(d1), .Y(D1_BUFFERED) );
  
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf8( .A(Q0), .Y(q0_buffered) );
  (* keep *)(* dont_touch = "true" *) sg13g2_buf_1 extrabuf9( .A(Q1), .Y(q1_buffered) );
 	
  dynamic_shift_reg_june_test dynamicshiftreginst (
  `ifdef USE_POWER_PINS
      .VDD(VPWR),
      .VSS(VGND),
  `endif
      .D0(D0_BUFFERED),
      .D1(D1_BUFFERED),
      .Q0(Q0),
      .Q1(Q1),
      .A0(A0),
      .B0(B0),
      .A1(A1),
      .B1(B1),
      .A2(A2),
      .B2(B2)
  );

endmodule
