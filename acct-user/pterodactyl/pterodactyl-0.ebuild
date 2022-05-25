# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Pterodactyl® is a free, open-source game server management panel built with PHP, React, and Go."
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( pterodactyl docker )
ACCT_USER_HOME=/var/lib/pterodactyl-daemon

acct-user_add_deps
