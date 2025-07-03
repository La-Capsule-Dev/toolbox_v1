#!/usr/bin/env bash

echo_status_sleep(){
  local text="$1"

  echo "" 
  echo "$text"
  echo ""
}

echo_status_ok(){
  local text="                      ✅ OK ✅"

  echo "" 
  echo "$text"
  echo ""
}

