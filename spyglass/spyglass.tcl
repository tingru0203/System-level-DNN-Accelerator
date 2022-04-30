# readfile
								   
set HDL_DIR "hardware"
set SOURCE_FILE "$HDL_DIR/lenet_rtl_basic_dma64.v $HDL_DIR/SRAM_activation_1024x32b.v $HDL_DIR/SRAM_weight_16384x32b.v"
set RPT_FILE "spyglass.rpt"
read_file -type verilog $SOURCE_FILE

#goal setup (lint_rtl)
current_goal lint/lint_rtl -alltop
run_goal
capture $RPT_FILE {write_report moresimple}

#goal setup (lint_turbo_rtl)
current_goal lint/lint_turbo_rtl -alltop
run_goal
capture -append $RPT_FILE {write_report moresimple}

#goal setup (lint_functional_rtl)
current_goal lint/lint_functional_rtl -alltop
run_goal
capture -append $RPT_FILE {write_report moresimple}

#goal setup (lint_abstract)
current_goal lint/lint_abstract -alltop
run_goal
capture -append $RPT_FILE {write_report moresimple}

#goal setup (adv_lint_struct)
current_goal adv_lint/adv_lint_struct -alltop
run_goal
capture -append $RPT_FILE {write_report moresimple}

#goal setup (adv_lint_verify)
current_goal adv_lint/adv_lint_verify -alltop
run_goal
capture -append $RPT_FILE {write_report moresimple}
