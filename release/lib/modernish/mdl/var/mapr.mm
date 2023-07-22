#! /module/for/moderni/sh


if not str eq "$1" "${_Msh_use_F-}"; then
	putln "${CCt}Warning: the var/mapr module was renamed to sys/cmd/mapr." \
		"${CCt}Please update the respective 'use' command in your script." \
		"${CCt}This compatibility redirect will go away in a future version."
fi

use sys/cmd/mapr
