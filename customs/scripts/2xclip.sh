#!/bin/sh
awk '{printf "%s", $0}' | xclip
