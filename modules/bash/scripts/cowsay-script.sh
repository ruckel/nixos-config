#!/usr/bin/env bash
#usage: $cowsay-scriptus
DATE=$(ddate +'the %e of %B%, %Y')
cowsay "Hello, world! Today is $DATE. prev exit code $1"
