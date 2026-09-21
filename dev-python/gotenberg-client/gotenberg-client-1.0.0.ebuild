# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A Python client for interfacing with the Gotenberg API"
HOMEPAGE="
	https://github.com/stumpylog/gotenberg-client
	https://pypi.org/project/gotenberg-client/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
# mostly docker dependent
RESTRICT="test"

DOCS=( README.md )

pkg_postinst() {
	optfeature "httpx backend" dev-python/httpx
	optfeature "requests backend" dev-python/requests
	optfeature "MIME-type detection" dev-python/python-magic
}
