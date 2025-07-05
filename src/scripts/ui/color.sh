# Escape code
esc=`echo -en "\033"`

#HACK: Supprimer ?

# Set colors
cc_red="${esc}[01;31m"
cc_red_back="${esc}[041;1m"
cc_green="${esc}[0;32m"
cc_yellow="${esc}[037;1m"
cc_yellow_back="${esc}[0;43m"
cc_normal=`echo -en "${esc}[m\017"`
