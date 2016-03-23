#!/bin/sh

HERE=`pwd`

echo "=== Install nasm ==="
tar xf nasm*.tar.* && cd nasm* && ./configure --prefix=${HERE} && make && make install && cd ..

echo "=== Update PATH ==="
PATH=${HERE}/bin:$PATH
	
echo "=== Install libjpeg-turbo ==="
tar xf libjpeg-turbo*.tar.* && cd libjpeg* && sed -i -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' Makefile.in && ./configure --prefix=${HERE} --with-jpeg8 --disable-static && make && make install && cd ..

echo "=== Install FLTK ==="
tar xf fltk*.tar.* && cd fltk* && sed -i -e '/cat./d' documentation/Makefile && ./configure --prefix=${HERE} --enable-shared && make && make install && cd .. 

echo "=== Install TigerVNC ==="
tar xf tigervnc*.tar.* && cd tigervnc* && patch -Np1 -i ../tigervnc-1.6.0-xorg118-1.patch && patch -Np1 -i ../tigervnc-1.6.0-gethomedir-1.patch && mkdir -p build && cd build && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${HERE} -DCMAKE_BUILD_TYPE=Release -Wno-dev .. && make && make install && cd ../../
