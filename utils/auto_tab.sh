#!/usr/bin/env bash

# 每次执行init都会重写该文件，如手动修改了本文件请及时保存
# 每次执行init都会重写该文件，如手动修改了本文件请及时保存
# 每次执行init都会重写该文件，如手动修改了本文件请及时保存

_kt_auto_tab(){
  opts1="create delete watch build install uninstall init help -help --help"
  opts2="evs obs sfs-turbo ccm ccm-normal ccm-eip ccm-affinity ccm-existing"
  opts3="pod pvc pv deployment daemonset service node ds svc"
	case ${COMP_CWORD} in
	1)
		COMPREPLY=($(compgen -W "${opts1}" -- ${COMP_WORDS[COMP_CWORD]}));;
	2)
		if [[ ${COMP_WORDS[1]} == "create" || ${COMP_WORDS[1]} == "delete" ]]; then
		  COMPREPLY=($(compgen -W "${opts2}" -- ${COMP_WORDS[COMP_CWORD]}))
		elif [[ ${COMP_WORDS[1]} == "install" || ${COMP_WORDS[1]} == "uninstall" ]]; then
		  COMPREPLY=($(compgen -W "${opts2}" -- ${COMP_WORDS[COMP_CWORD]}))
        elif [[ ${COMP_WORDS[1]} == "build" ]]; then
		  COMPREPLY=($(compgen -W "${opts2}" -- ${COMP_WORDS[COMP_CWORD]}))
        elif [ ${COMP_WORDS[1]} == "watch" ]; then
		  COMPREPLY=($(compgen -W "${opts3}" -- ${COMP_WORDS[COMP_CWORD]}))
		fi
	esac
}
complete -F _kt_auto_tab kt
