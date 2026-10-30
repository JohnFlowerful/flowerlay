# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Provides Django Channels channel layers that use Redis as a backing store"
HOMEPAGE="
	https://github.com/django/channels_redis
	https://pypi.org/project/channels-redis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/asgiref-3.9.1[${PYTHON_USEDEP}]
	>=dev-python/channels-4.2.2[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	>=dev-python/redis-5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/async-timeout[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

EPYTEST_PLUGINS=( pytest-{asyncio,timeout} )
EPYTEST_IGNORE=(
	# Ignore sentinel tests
	tests/test_pubsub_sentinel.py
	tests/test_sentinel.py
)
distutils_enable_tests pytest

python_test() {
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

	cleanup() {
		pkill -F "${redis_pidfile}"
	}
	trap cleanup EXIT

	epytest
}

pkg_postinst() {
	optfeature "Backend encryption support" dev-python/cryptography
}
