# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( gotify )
ACCT_USER_HOME=/var/lib/gotify

acct-user_add_deps
