# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A modern web UI for various torrent clients with a Node.js backend and React frontend."
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( flood )
ACCT_USER_HOME=/var/lib/flood

acct-user_add_deps
