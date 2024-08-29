#!/usr/bin/env bash

# 每次执行init都会重写该文件，如手动修改了本文件请及时保存
# 每次执行init都会重写该文件，如手动修改了本文件请及时保存
# 每次执行init都会重写该文件，如手动修改了本文件请及时保存

_kt_auto_tab(){
  opts1="create delete watch build install uninstall init help -help --help version -version --version -v --v"
  opts2="evs obs sfsturbo ccm cluster"
  evs_cmd="evs-default evs-parameter evs-deny-resize evs-allow-resize evs-snapshot evs-rwo evs-rwx"
  obs_cmd="obs-default obs-parameter obs-exist obs-encryption"
  sfsturbo_cmd="sfsturbo-default sfsturbo-performance sfsturbo-deny-resize sfsturbo-allow-resize sfsturbo-static"
  ccm_cmd="ccm-normal ccm-eip ccm-affinity ccm-existing"
  opts3="pod pvc pv deployment daemonset service node dep ds svc"
  help_cmd="--help"
  ds_cmd="--ds"
	case ${COMP_CWORD} in
	1)
		COMPREPLY=($(compgen -W "${opts1}" -- ${COMP_WORDS[COMP_CWORD]}));;
	2)
		if [[ ${COMP_WORDS[1]} == "create" || ${COMP_WORDS[1]} == "delete" ]]; then
		  COMPREPLY=($(compgen -W "${opts2} ${evs_cmd} ${obs_cmd} ${sfsturbo_cmd} ${ccm_cmd} ${help_cmd}" -- ${COMP_WORDS[COMP_CWORD]}))
		elif [[ ${COMP_WORDS[1]} == "install" || ${COMP_WORDS[1]} == "uninstall" ]]; then
		  COMPREPLY=($(compgen -W "${opts2} ${help_cmd}" -- ${COMP_WORDS[COMP_CWORD]}))
        elif [[ ${COMP_WORDS[1]} == "build" ]]; then
		  COMPREPLY=($(compgen -W "${opts2} ${help_cmd}" -- ${COMP_WORDS[COMP_CWORD]}))
        elif [ ${COMP_WORDS[1]} == "watch" ]; then
		  COMPREPLY=($(compgen -W "${opts3} ${help_cmd}" -- ${COMP_WORDS[COMP_CWORD]}))
		fi
	esac
}
complete -F _kt_auto_tab kt
