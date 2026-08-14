# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A certbot plugin for enabling DNS authentication with dynadot"
HOMEPAGE="
	https://github.com/dmig/certbot-dns-dynadot
	https://pypi.org/project/certbot-dns-dynadot/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
# no tests provided
RESTRICT="test"

RDEPEND="
	>=app-crypt/certbot-2.11.0
	dev-python/requests
"

src_prepare() {
	default

	sed -i '/install_requires=\[/,/^[[:space:]]*\],/d' setup.py
}
