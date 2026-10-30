# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

ENDESIVE_COMMIT="8ce2b3928f82c6c74e70fb4d32ab3ebe35536134"

inherit distutils-r1

DESCRIPTION="Sign and verify digital signatures in mail, PDF and XML documents"
HOMEPAGE="
	https://github.com/m32/endesive
	https://pypi.org/project/endesive/
"
SRC_URI="
	https://github.com/m32/endesive/archive/${ENDESIVE_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${ENDESIVE_COMMIT}"

LICENSE="MIT LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="
	dev-python/asn1crypto[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/cryptography-45.0.0[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pykcs11[${PYTHON_USEDEP}]
	dev-python/pypdf[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test?  (
		dev-libs/softhsm
		media-fonts/dejavu
	)
"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.16-fontdir.patch"
)

distutils_enable_tests unittest

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

src_prepare() {
	default

	if use test; then
		# fix relative import
		sed -i 's/^from test_cert import (/from .test_cert import (/' \
			tests/test_email.py \
			tests/test_hsm.py \
			tests/test_pdf.py \
			tests/test_plain.py || die

		# Missing ssh agent
		sed -i -re \
			's/def (test_ssh_sign|test_ssh_verify)/def _\1/' \
			tests/test_hsm.py || die

		# Requires network
		sed -i -re \
			's/def (test_pdf_timestamp)/def _\1/' \
			tests/test_pdf.py || die
	fi
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}
