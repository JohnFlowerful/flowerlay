# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Digital signatures for PDF, S/MIME, XML (XAdES), and CMS in Python"
HOMEPAGE="
	https://github.com/m32/endesive
	https://pypi.org/project/endesive/
"
SRC_URI="https://github.com/m32/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

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

distutils_enable_tests unittest

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

src_prepare() {
	default

	if use test; then
		# fix relative imports
		sed -i 's/^from test_cert import /from .test_cert import /' \
			tests/test_email.py \
			tests/test_hsm.py \
			tests/test_pdf.py \
			tests/test_plain.py \
			tests/test_tsp.py \
			tests/test_xades.py || die

		sed -i 's/^from fake_tsa import /from .fake_tsa import /' \
			tests/test_security_signer.py \
			tests/test_tsp.py \
			tests/test_xades.py || die

		# correct font dir
		sed -i 's|/usr/share/fonts/truetype/dejavu/|/usr/share/fonts/dejavu/|g' \
			tests/test_pdf.py

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
