#!/bin/bash

pingFunc(){
  local url="$1"
  ping "$url"
}

pingFunc "google.com"
