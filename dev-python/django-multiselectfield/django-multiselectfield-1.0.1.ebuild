# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Django multiple select field"
HOMEPAGE="
	https://github.com/goinnn/django-multiselectfield
	https://pypi.org/project/django-multiselectfield/
"
SRC_URI="https://github.com/goinnn/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"

DOCS=( README.rst )

python_test() {
	cd example || die
	"${EPYTHON}" -m django test app -v2 --settings=example.settings || die "Tests fail with ${EPYTHON}"
}
