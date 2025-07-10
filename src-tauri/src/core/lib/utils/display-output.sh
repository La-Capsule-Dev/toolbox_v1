
function display_output(){
    local h=${1-10}			# box height default 10
    local w=${2-41} 		# box width default 41
    local t=${3-Output} 	# box title
    dialog --backtitle "Linux Shell Script Tutorial" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}
