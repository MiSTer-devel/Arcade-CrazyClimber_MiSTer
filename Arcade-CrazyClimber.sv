//============================================================================
//  Arcade: CrazyClimber
//
//  Port to MiSTer
//  Copyright (C) 2017 Sorgelig
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module emu
(
	`include "sys/emu_ports.vh"
);

assign ADC_BUS  = 'Z;
assign USER_OUT = '1;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;
assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;
assign {DDRAM_CLK, DDRAM_BURSTCNT, DDRAM_ADDR, DDRAM_DIN, DDRAM_BE, DDRAM_RD, DDRAM_WE} = '0;  

assign VGA_F1 = 0;
assign VGA_SCALER  = 0;
assign VGA_DISABLE = 0;
assign HDMI_FREEZE = 0;
assign HDMI_BLACKOUT = 0;
assign HDMI_BOB_DEINT = 0;

assign LED_USER  = ioctl_download;
assign LED_DISK = 0;
assign LED_POWER = 0;
assign BUTTONS = 0;

wire [1:0] ar = status[20:19];

assign VIDEO_ARX =  (!ar) ? ( 12'd2560) : (ar - 1'd1);
assign VIDEO_ARY =  (!ar) ? ( 12'd2191) : 12'd0;

`include "build_id.v" 
localparam CONF_STR = {
	"A.CCLIMB;;",
	"H0OJK,Aspect ratio,Original,Full Screen,[ARC1],[ARC2];",
	"H0O35,Scandoubler Fx,None,HQ2x,CRT 25%,CRT 50%,CRT 75%;",
	"-;",
	"O6,Right Hand,Buttons,Second Joystick;",
	"-;",
	"DIP;",
	"-;",
	"R0,Reset;",
	"J1,R Right,R Left,R Down,R Up,Start 1P,Start 2P,Coin;",
	"jn,A,Y,B,X,Start,Select,R;",
	"V,v",`BUILD_DATE
};

////////////////////   CLOCKS   ///////////////////

wire clk_sys;
wire pll_locked;

pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys), // 48
	.locked(pll_locked)
);

///////////////////////////////////////////////////

wire [31:0] status;
wire  [1:0] buttons;
wire        direct_video;

wire        ioctl_download;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;
wire  [7:0] ioctl_index;

wire [15:0] joystick_0, joystick_1;
wire [15:0] joy = joystick_0 | joystick_1;

wire        forced_scandoubler;
wire [21:0] gamma_bus;

hps_io #(.CONF_STR(CONF_STR)) hps_io
(
	.clk_sys(clk_sys),
	.HPS_BUS(HPS_BUS),

	.buttons(buttons),
	.status(status),
	.status_menumask(direct_video),
	.forced_scandoubler(forced_scandoubler),
	.gamma_bus(gamma_bus),
	.direct_video(direct_video),

	.ioctl_download(ioctl_download),
	.ioctl_wr(ioctl_wr),
	.ioctl_addr(ioctl_addr),
	.ioctl_dout(ioctl_dout),
	.ioctl_index(ioctl_index),

	.joystick_0(joystick_0),
	.joystick_1(joystick_1)
);

// Dip switches from MRA file
reg [7:0] sw[8];
always @(posedge clk_sys) if (ioctl_wr && (ioctl_index==254) && !ioctl_addr[24:3]) sw[ioctl_addr[2:0]] <= ioctl_dout;

wire m_right  = joystick_0[0];
wire m_left   = joystick_0[1];
wire m_down   = joystick_0[2];
wire m_up     = joystick_0[3];
wire m_rright = status[6] ? joystick_1[0] : (joystick_0[4] | joystick_1[0]);
wire m_rleft  = status[6] ? joystick_1[1] : (joystick_0[5] | joystick_1[1]);
wire m_rdown  = status[6] ? joystick_1[2] : (joystick_0[6] | joystick_1[2]);
wire m_rup    = status[6] ? joystick_1[3] : (joystick_0[7] | joystick_1[3]);

wire m_start1 = joy[8];
wire m_start2 = joy[9];
wire m_coin   = joy[10];

wire hs, vs;
wire [2:0] r,g;
wire [1:0] b;

wire HSync = ~hs;
wire VSync = ~vs;
wire HBlank, VBlank;

reg ce_pix;
always @(posedge clk_sys) begin
        reg [2:0] div;

        div <= div + 1'd1;
        ce_pix <= !div;
end

arcade_video #(514,8) arcade_video
(
        .*,
        .clk_video(clk_sys),

        .RGB_in({r,g,b}),

        .fx(status[5:3])
);


wire [15:0] audio;
assign AUDIO_L = audio;
assign AUDIO_R = AUDIO_L;
assign AUDIO_S = 0;
assign AUDIO_MIX = 0;


reg ce_12;
//reg ce_6;
always @(negedge clk_sys) begin
	reg [2:0] div;

	div   <= div + 1'd1;
	ce_12 <= !div[1:0];
//	ce_6  <= !div[2:0];
end

crazy_climber crazy_climber
(
	.clock_12(clk_sys & ce_12),
	.reset(RESET | status[0] | buttons[1] | ioctl_download),

	.dn_clk(clk_sys),
	.dn_addr(ioctl_addr[15:0]),
	.dn_data(ioctl_dout),
	.dn_wr(ioctl_wr && !ioctl_index),

	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_hs(hs),
	.video_vs(vs),
	.video_hblank(HBlank),
	.video_vblank(VBlank),

	.audio_out(audio),

	.coin1(m_coin),
	.start1(m_start1),
	.start2(m_start2),

	.l_up1(m_up),
	.l_down1(m_down),
	.l_left1(m_left),
	.l_right1(m_right),
	.r_up1(m_rup),
	.r_down1(m_rdown),
	.r_left1(m_rleft),
	.r_right1(m_rright),

	.l_up2(m_up),
	.l_down2(m_down),
	.l_left2(m_left),
	.l_right2(m_right),
	.r_up2(m_rup),
	.r_down2(m_rdown),
	.r_left2(m_rleft),
	.r_right2(m_rright),

	.cabinet(sw[1][0]),
	.dip_sw(sw[0])
);

endmodule
