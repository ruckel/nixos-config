#!/usr/bin/env bash

minute=$(date +%M)
echo minute: $minute
setFuzzyDate() {
  if   (( $1 < 5 ));  then fuzzyDate="0<5"
  elif (( $1 < 10 )); then fuzzyDate="5<10"
  elif (( $1 < 15 )); then fuzzyDate="10<15"
  elif (( $1 < 20 )); then fuzzyDate="15<20"
  elif (( $1 < 25 )); then fuzzyDate="20<25"
  elif (( $1 < 30 )); then fuzzyDate="25<30"
  elif (( $1 < 35 )); then fuzzyDate="30<35"
  elif (( $1 < 40 )); then fuzzyDate="35<40"
  elif (( $1 < 45 )); then fuzzyDate="40<45"
  elif (( $1 < 50 )); then fuzzyDate="45<50"
  elif (( $1 < 55 )); then fuzzyDate="50<55"
  else fuzzyDate="55<60"
  fi
}
setFuzzyDate $minute
echo $fuzzyDate
