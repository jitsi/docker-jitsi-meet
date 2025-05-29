#!/bin/bash

curl --fail-with-body http://127.0.0.1:$PROSODY_HTTP_PORT/health
