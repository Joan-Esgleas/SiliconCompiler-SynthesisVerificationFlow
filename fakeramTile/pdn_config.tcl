####################################
# Macro PDN grid for fakeram45_32x32
#
# The macro already has metal4 vertical power pins (VDD/VSS) defined
# in its LEF.  We do NOT add extra metal4 stripes because the
# pitch=10/offset=2 stripes land at x=2..2.93, 12..12.93 which
# covers only two VSS pins and zero VDD pins (VDD pins sit at
# x=3.64, 7.0, 10.36, 13.72 ... — entirely between the stripes).
#
# Instead, we add metal5 *horizontal* stripes.  Because the macro's
# metal4 pins are full-height vertical bars, every metal5 stripe
# crosses every metal4 pin regardless of its X position.
# Pdngen assigns VDD/VSS to alternating stripes and places vias
# only where the net assignment matches the metal4 pin, so each
# stripe correctly picks up its own net.
# Chain: macro metal4 (V) → metal5 (H) → metal6 (V) → metal7 (H, core).
####################################
define_pdn_grid -name {fakeram45} -voltage_domains {CORE} -macro \
    -orient {R0 R180 MX MY} \
    -halo {2.0 2.0 2.0 2.0} \
    -cells {fakeram45_.*}
add_pdn_stripe -grid {fakeram45} -layer {metal5} -width {0.93} -pitch {10.0} -offset {2}
add_pdn_stripe -grid {fakeram45} -layer {metal6} -width {0.93} -pitch {20.0} -offset {2}
add_pdn_connect -grid {fakeram45} -layers {metal4 metal5}
add_pdn_connect -grid {fakeram45} -layers {metal5 metal6}
add_pdn_connect -grid {fakeram45} -layers {metal6 metal7}

####################################
# Supplementary metal7 stripes for the core grid
#
# The nangate45 default adds metal7 at pitch=40, offset=2.
# Macro height is 33.6 um < 40 um, so tightly-packed macros in Y
# can fall entirely between two metal7 stripes with no via.
# Adding a second set at offset=22 fills the gaps, making the
# effective pitch 20 um and guaranteeing every macro (33.6 um
# tall + 2 um halo = 37.6 um) has at least one metal7 crossing.
####################################
add_pdn_stripe -grid {grid} -layer {metal7} -width {1.40} -pitch {40.0} -offset {22}