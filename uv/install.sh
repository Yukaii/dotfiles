#! /usr/bin/env bash
cat packages.txt | xargs -n 1 uv tool install