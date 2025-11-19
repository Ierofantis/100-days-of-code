load_package project

set proj_name test5

if {[file exists "${proj_name}.qpf"]} {
    project_open $proj_name
} else {
    project_new $proj_name -overwrite
}

set_global_assignment -name TOP_LEVEL_ENTITY test5
set_global_assignment -name VHDL_FILE sqrt4.vhd
set_global_assignment -name VHDL_FILE test5.vhd

project_close
