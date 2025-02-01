# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( hydroxide )
ACCT_USER_HOME=/var/lib/hydroxide

acct-user_add_deps
