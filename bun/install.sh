#! /usr/bin/env bash
cat packages.txt | xargs -n 1 bun install --global
