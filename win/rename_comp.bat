set new_comp=new_comp
WMIC computersystem where caption="%computername%" rename "%new_comp%"