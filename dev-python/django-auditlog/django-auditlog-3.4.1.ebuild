# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Audit log app for Django"
HOMEPAGE="
	https://github.com/jazzband/django-auditlog
	https://pypi.org/project/django-auditlog/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	doc? (
		dev-python/psycopg[${PYTHON_USEDEP}]
	)
	test? (
		dev-db/postgresql[server]
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme

python_test() {
	local pgsql_datadir="${T}/pgsql"
	local pgsql_port=5432
	local pgsql_install_log="${T}/pgsql_install.log"
	local pgsql_log="${T}/pgsql.log"

	einfo "Creating postgresql test instance ..."
	if ! initdb \
		--username=postgres \
		--pgdata="${pgsql_datadir}" >& "${pgsql_install_log}"
	then
		cat "${pgsql_install_log}"
		die "Failed to create database"
	fi

	einfo "Starting postgresql test instance ..."
	pg_ctl start \
		--options="-h '127.0.0.1' -p ${pgsql_port} -k '${T}'" \
		--wait \
		--log="${pgsql_log}" \
		--pgdata="${pgsql_datadir}" || die

	psql \
		--host="${T}" \
		--username=postgres \
		--dbname=postgres \
		--command="ALTER ROLE postgres WITH PASSWORD '';" || die

	createdb --host="${T}" --username=postgres auditlog || die

	cleanup_pgsql() {
		einfo "Cleaning up test pgsql instance ..."
		if [[ -n "${pgsql_datadir}" ]]; then
			pg_ctl -w -D "${pgsql_datadir}" stop
		fi
	}

	cd "${S}/auditlog_tests"
	if ! "${EPYTHON}" -m django test -v2 --settings=test_settings; then
		cleanup_pgsql
		die "Tests fail with ${EPYTHON}"
	fi
	cleanup_pgsql
}
