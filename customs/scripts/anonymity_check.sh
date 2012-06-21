#!/bin/bash

# Checks the effectiveness of the various anonymizing proxies.

PS3='What kind of anonymity test do you want to do?'
select anonymity_test in 'General' 'Tor'; do
	case "${anonymity_test}" in
		'General' )
			vimprobable2 http://checker.samair.ru/ &
			vimprobable2 http://www.stayinvisible.com/ &
			break
			;;
		'Tor' )
			vimprobable2 https://check.torproject.org/ &
			break
			;;
	esac
done
