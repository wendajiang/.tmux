#!/bin/bash

#!/bin/bash

TMUX_VERSION=3.1c
NCURSES_VERSION=6.2
LIBEVENT_VERSION=2.1.12

BASEDIR=${HOME}/work/tmux-static
TMUXTARGET=${BASEDIR}/local
mkdir -p $TMUXTARGET
cd $BASEDIR

export PKG_CONFIG_PATH="${TMUXTARGET}/lib/pkgconfig"

if [ ! -f libevent-${LIBEVENT_VERSION}-stable.tar.gz ]; then
	wget -O libevent-${LIBEVENT_VERSION}-stable.tar.gz https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz
fi
if [ ! -f ncurses-${NCURSES_VERSION}.tar.gz ]; then
	wget -O ncurses-${NCURSES_VERSION}.tar.gz http://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
fi
if [ ! -f tmux-${TMUX_VERSION}.tar.gz ]; then
	wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
fi

if [ ! -d libevent-${LIBEVENT_VERSION}-stable ]; then
	cd ${BASEDIR}
	tar -xzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
	cd ${BASEDIR}/libevent-${LIBEVENT_VERSION}-stable
	./configure --prefix=$TMUXTARGET --disable-shared
	make && make install
fi

if [ ! -d ncurses-${NCURSES_VERSION} ]; then
	cd ${BASEDIR}
	tar -xzf ncurses-${NCURSES_VERSION}.tar.gz
	cd ${BASEDIR}/ncurses-${NCURSES_VERSION}
	./configure --prefix=$TMUXTARGET --with-default-terminfo-dir=/usr/share/terminfo --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo" --with-shared
	make && make install
fi

if [ ! -d tmux-${TMUX_VERSION} ]; then
	cd ${BASEDIR}
	tar -xzf tmux-${TMUX_VERSION}.tar.gz
	cd tmux-${TMUX_VERSION}
	./configure --prefix=$TMUXTARGET --enable-static CFLAGS="-I${TMUXTARGET}/include -I${TMUXTARGET}/include/ncurses" LDFLAGS="-L${TMUXTARGET}/lib -L${TMUXTARGET}/include -L${TMUXTARGET}/include/ncurses" LIBEVENT_CFLAGS="-I${TMUXTARGET}/include" LIBEVENT_LIBS="-L${TMUXTARGET}/lib -levent" LIBNCURSES_CFLAGS="-I${TMUXTARGET}/include" LIBNCURSES_LIBS="-L${TMUXTARGET}/lib -lncurses"
	make && make install
fi

if [ -f $TMUXTARGET/bin/tmux ]; then
	$TMUXTARGET/bin/tmux -V
	echo "`whoami`@`hostname -d`:${TMUXTARGET}/bin/tmux"
fi

