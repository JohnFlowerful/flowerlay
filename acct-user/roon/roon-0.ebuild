# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A music management and listening solution"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( roon )
ACCT_USER_HOME=/var/lib/roon

acct-user_add_deps
