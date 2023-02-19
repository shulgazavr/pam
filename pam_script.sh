#!/bin/bash

if groups $PAM_USER | grep admin; then
    exit 0;
else
    if [[ $(date +%u) -gt 5 ]]; then
        exit 1;
    fi
fi
