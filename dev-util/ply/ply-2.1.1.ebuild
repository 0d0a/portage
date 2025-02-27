# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="Dynamic instrumentation of the Linux kernel with BPF and kprobes"
HOMEPAGE="https://github.com/iovisor/ply"
SRC_URI="https://github.com/iovisor/ply/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="static-libs"

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~BPF_JIT ~HAVE_BPF_JIT ~BPF_EVENTS"

	check_extra_config
}

src_prepare() {
	sed -i "/^AC_INIT/c\AC_INIT(${PN}, ${PV}," configure.ac || die
	eapply "${FILESDIR}/${P}-arm-build-fix.patch"
	eapply_user
	eautoreconf
}

src_install() {
	default
	rm -f "${ED}/usr/share/doc/${P}/COPYING"

	if ! use static-libs; then
		find "${D}" -type f -name '*.a' -delete || die
	fi
}
