#!/bin/bash
offsetLimitIndex=$1
BCS_PORT=${BCS_PORT:-9222}
offsetLimitIndex=${offsetLimitIndex:-99}
echo "offsetLimitIndex: $offsetLimitIndex"


# go:recordmp3> go:record+lame > just parec+lame
url="localhost:$BCS_PORT/display$offsetLimitIndex-audio.mp3?stream=true&advertise=true"
exec parec --format=s16le -d xrdp-sink.monitor |lame -r -ab 52 - - \
  | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  "$url"

