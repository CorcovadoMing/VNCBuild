#!/bin/bash

BUILD_XORG=0
BUILD_X0VNC=1
BUILD_XVNC=1

HERE=`pwd`

if [ $BUILD_X0VNC == 1 ]; then
echo "=== Install nasm ==="
tar xf nasm*.tar.* && cd nasm* && ./configure --prefix=${HERE} && make && make install && cd ..

echo "=== Update PATH ==="
PATH=${HERE}/bin:$PATH
LDFLAGS=-L${HERE}/lib:$LDFLAGS
CFLAGS=-I${HERE}/include:$CFLAGS
	
echo "=== Install libjpeg-turbo ==="
tar xf libjpeg-turbo*.tar.* && cd libjpeg* && sed -i -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' Makefile.in && ./configure --prefix=${HERE} --with-jpeg8 && make && make install && cd ..

echo "=== Install FLTK ==="
tar xf fltk*.tar.* && cd fltk* && sed -i -e '/cat./d' documentation/Makefile && ./configure --prefix=${HERE} --enable-shared && make && make install && cd .. 

echo "=== Install TigerVNC ==="
tar xf tigervnc*.tar.* && cd tigervnc* && patch -Np1 -i ../tigervnc-1.6.0-xorg118-1.patch && patch -Np1 -i ../tigervnc-1.6.0-gethomedir-1.patch && mkdir -p build && cd build && cmake -G "Unix Makefiles" -DJPEG_INCLUDE_DIR=../../include -DJPEG_LIBRARY=../../lib/libjpeg.a -DCMAKE_INSTALL_PREFIX=${HERE} -DCMAKE_BUILD_TYPE=Release -Wno-dev .. && make && make install && cd ../../
fi

if [ $BUILD_XORG == 1 ]; then
bash build-x-app.sh
fi

if [ $BUILD_XVNC == 1 ]; then
echo "=== Install Xorg-macro ==="
tar xf util-macro*.tar.* && cd util-macro* && ./configure $XORG_CONFIG --prefix=$HERE && make install && cd .. 

echo "=== Install libxshmfence ==="
tar xf libxshmfence-*.tar.* && cd libxshmfence* && ./configure $XORG_CONFIG --prefix=$HERE && make && make install && cd .. 

echo "=== Install Xvnc ==="
cd tigervnc* && cd build && cp -vR ../unix/xserver unix/ && tar -xf ../../xorg-server-1.17.2.tar.bz2 -C unix/xserver --strip-components=1 && cd unix/xserver && patch -Np1 -i ../../../unix/xserver117.patch && autoreconf -fi -I$HERE/share/aclocal \
      && PKG_CONFIG_PATH=$HERE/lib/pkgconfig ./configure $XORG_CONFIG \
      --disable-xwayland    --disable-dri        --disable-dmx         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --disable-static      --enable-dri3                              \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --with-pic --prefix=${HERE} \
      && make TIGERVNC_SRCDIR=`pwd`/../../../ && make install
fi
