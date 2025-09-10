YOSYS=yosys
NEXTPNR=nextpnr-ecp5
ECPPACK=ecppack
HDMICODE=DVI_3x3.v
HDMICODE=llhdmi.v vgatestsrc.v keyboard.v
ENCODER=TMDS_encoder.v

.PHONY: all
all: colorlight_i9_keyboard.bit

ULX3S_25F.ys: ULX3S_25F.v $(HDMICODE) $(ENCODER) clock.v OBUFDS.v
	chmod +x ysgen.sh
	./ysgen.sh ULX3S_25F.v  $(HDMICODE) $(ENCODER) clock.v \
		OBUFDS.v  > ULX3S_25F.ys
	echo "hierarchy -top ULX3S_25F" >> ULX3S_25F.ys
	echo "synth_ecp5 -json ULX3S_25F.json" >> ULX3S_25F.ys

ULX3S_25F.json: ULX3S_25F.ys
	$(YOSYS) -q ULX3S_25F.ys

ulx3s_25f_ULX3S_25F.config: ULX3S_25F.json
	$(NEXTPNR) --45k --package CABGA381 --json ULX3S_25F.json --lpf ulx3s_v20_segpdi.lpf \
	--textcfg ulx3s_25f_ULX3S_25F.config

colorlight_i9_keyboard.bit: ulx3s_25f_ULX3S_25F.config
	$(ECPPACK) --input ulx3s_25f_ULX3S_25F.config \
		--bit colorlight_i9_keyboard.bit
        
.PHONY: clean
clean:
	rm -f ULX3S_25F.ys ULX3S_25F.json ulx3s_25f_ULX3S_25F.config \
		colorlight_i9_keyboard.bit
