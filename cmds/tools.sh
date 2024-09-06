#!/usr/bin/env bash

function f_install_clear() {
    env_dir="/etc/profile"
    script_dir="/root/scripts"

    if [[ ! -d ${script_dir} ]] ; then
        sudo mkdir ${script_dir}
    fi

    sudo touch ${script_dir}/c
    sudo chmod 777 -R ${script_dir}

sudo cat <<EOF>> ${script_dir}/c
clear
clear
clear
clear
clear

EOF

    echo 'export PATH=$PATH:/root/scripts' >> ${env_dir}
    source ${env_dir}
}
