#!/bin/sh
/usr/bin/keychain -q --nogui $HOME/.ssh/id-ed25519
source $HOME/.keychain/$HOST-sh
