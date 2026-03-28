# Custom PDN configuration for SRAM macro integration
#
# Based on librelane's default pdn_cfg.tcl.

source $::env(SCRIPTS_DIR)/openroad/common/set_global_connections.tcl
set_global_connections

# 1. Map the physical pin names (VPWR/VGND) to the logical net names (VDD/VSS)
# This ensures that when the tool sees a pin named 'VPWR', it treats it as 'VDD'.
add_global_connection -net $::env(VDD_NET) -pin_pattern {^VPWR$} -power
add_global_connection -net $::env(GND_NET) -pin_pattern {^VGND$} -ground

# 2. Define a "dummy" macro grid 
# We need this because 'add_pdn_connect' must be associated with a grid name.
# We don't add any stripes to it; it just serves as a container for the connection rule.
define_pdn_grid -macro -default -name macro_stitch

# 3. The Only Functional Command: Drop Vias
# This will automatically place Via3 anywhere Metal 3 (pins) and Metal 4 (stripes) overlap.
add_pdn_connect -grid macro_stitch -layers "Metal3 Metal4"
