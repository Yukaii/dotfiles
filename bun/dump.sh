#! /usr/bin/env bash
bun pm ls -g | awk '/├── |└── /{print $2}' > packages.txt
