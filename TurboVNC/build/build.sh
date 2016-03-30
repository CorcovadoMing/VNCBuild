#!/bin/sh

HERE=`pwd`

echo "=== Install nasm ==="
tar xf nasm*.tar.* && cd nasm* && ./configure --prefix=${HERE} && make && make install && cd ..

echo "=== Update PATH ==="
PATH=${HERE}/bin:$PATH
LDFLAGS=-L${HERE}/lib:$LDFLAGS
CFLAGS=-I${HERE}/include:$CFLAGS

echo "=== Install libjpeg-turbo ==="
tar xf libjpeg-turbo*.tar.* && cd libjpeg* && sed -i -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' Makefile.in && ./configure --prefix=${HERE} --with-jpeg8 --disable-static && make && make install && cd ..

echo "=== Install TurboVNC ==="
cd turbovnc && rm -rf build && mkdir -p build && cd build && cmake -G "Unix Makefiles" -DTJPEG_LIBRARY="-L${HERE}/lib -lturbojpeg" -DTVNC_BINDIR=${HERE}/bin -DTVNC_DOCDIR=${HERE}/doc -DTJPEG_INCLUDE_DIR=${HERE}/include -DCMAKE_INSTALL_PREFIX=${HERE}/bin -DTVNC_BUILDJAVA=0  .. && make && make install  
