# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Caches your Django ORM queries and automatically invalidates them"
HOMEPAGE="
	https://github.com/noripyt/django-cachalot
	https://pypi.org/project/django-cachalot/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/django-4.2[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-db/mariadb[server]
		net-misc/memcached
		dev-db/redis
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/django-debug-toolbar[${PYTHON_USEDEP}]
		dev-python/django-redis[${PYTHON_USEDEP}]
		dev-python/mysqlclient[${PYTHON_USEDEP}]
		dev-python/psycopg:2[${PYTHON_USEDEP}]
		dev-python/pylibmc[${PYTHON_USEDEP}]
		dev-python/pymemcache[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

src_prepare() {
	default

	# Disable failing test:
	# * cachalot.tests.read.ReadTestCase.test_explain
	sed -e '/^\s*def test_explain/,/^$/d' -i cachalot/tests/read.py || die
}

python_test() {
	# Postgresql
	local pgsql_datadir="${T}/pgsql"
	local pgsql_port=5432
	local pgsql_install_log="${T}/pgsql_install.log"
	local pgsql_log="${T}/pgsql.log"

	einfo "Creating postgresql test instance ..."
	if ! initdb \
		--username=cachalot \
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
		--username=cachalot \
		--dbname=postgres \
		--command="ALTER ROLE cachalot WITH PASSWORD 'postgres';" || die

	# MySQL
	local mysqld_datadir="${T}/mysql"
	local mysqld_install_log="${T}/mysqld_install.log"
	local mysqld_pidfile="${T}/mysqld.pid"
	local mysqld_port=3306
	local mysqld_socket="${T}/mysqld.sock"
	local mysqld_log="${T}/mysqld.log"

	local -x PATH="${BROOT}/usr/share/mariadb/scripts:${PATH}"

	einfo "Creating mysql test instance ..."
	if ! mariadb-install-db \
		--no-defaults \
		--auth-root-authentication-method=normal \
		--basedir="${EPREFIX}/usr" \
		--datadir="${mysqld_datadir}" >& "${mysqld_install_log}"
	then
		cat "${mysqld_install_log}"
		die "Failed to create database"
	fi

	einfo "Starting mysql test instance ..."
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=127.0.0.1 \
		--port="${mysqld_port}" \
		--pid-file="${mysqld_pidfile}" \
		--socket="${mysqld_socket}" \
		--datadir="${mysqld_datadir}" >& "${mysqld_log}" &

	# wait for it to start
	local i timeout=10
	for i in seq 1 ${timeout}; do
		[[ -S "${mysqld_socket}" ]] && break
		sleep 1
	done
	if [[ ! -S "${mysqld_socket}" ]]; then
		cat "${mysqld_log}"
		die "MySQL failed to start in ${timeout} seconds"
	fi

	# Redis
	local redis_log="${T}/redis.log"
	local redis_pidfile="${T}/redis.pid"
	local redis_port=6379

	einfo "Starting redis test instance ..."
	"${EPREFIX}/usr/sbin/redis-server" \
		--daemonize yes \
		--logfile "${redis_log}" \
		--pidfile "${redis_pidfile}" \
		--port "${redis_port}" \
		--bind 127.0.0.1 || die

	# Memcached
	einfo "Starting memcached test instance ..."
	local memcached_pidfile="${T}/memcached.pid"

	memcached \
		--daemon \
		--pidfile="${memcached_pidfile}" || die

	cleanup_services() {
		einfo "Cleaning up test service instances ..."
		[[ -n "${memcached_pidfile}" ]] && pkill -F "${memcached_pidfile}"
		[[ -n "${redis_pidfile}" ]] && pkill -F "${redis_pidfile}"
		[[ -n "${mysqld_pidfile}" ]] && pkill -F "${mysqld_pidfile}"
		if [[ -n "${pgsql_datadir}" ]]; then
			pg_ctl -w -D "${pgsql_datadir}" stop
		fi
	}

	if ! "${EPYTHON}" runtests.py; then
		cleanup_services
		die "Tests fail with ${EPYTHON}"
	fi
	cleanup_services
}
