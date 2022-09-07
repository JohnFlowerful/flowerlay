# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A third-party ProtonMail bridge serving SMTP and IMAP"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( peroxide )
ACCT_USER_HOME=/var/lib/peroxide

acct-user_add_deps
