#!/bin/sh
echo hibernating
dunstify hibernating
exec systemctl hibernate
