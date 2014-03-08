#!/bin/bash
# this downloads and compiles current version of ffmpeg

SRC=$HOME/src/ffmpeg
BUILD=$HOME/src/ffmpeg/build
BIN=$HOME/bin
JOBS=2
export "PATH=$PATH:$BIN"

#create dirs if not existent
mkdir -p $SRC
mkdir -p $BUILD
mkdir -p $BIN


## yasm
cd $SRC
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$SRC" --bindir="$BIN"
make -j $JOBS
make install
make distclean

## x264 
cd $SRC
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
./configure --prefix="$SRC" --bindir="$BIN" --enable-static
make -j $JOBS
make install
make distclean

##
cd $SRC
wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$SRC" --disable-shared
make -j $JOBS
make install
make distclean

#opus
cd $SRC
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$SRC" --disable-shared
make -j $JOBS
make install
make distclean


#libvpx
cd $SRC
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --prefix="$SRC" --disable-examples
make -j $JOBS
make install
make clean


#ffmpeg
cd $SRC
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd $SRC/ffmpeg
PKG_CONFIG_PATH="$BUILD/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$SRC" --extra-cflags="-I$BUILD/include" \
   --extra-ldflags="-L$BUILD/lib" --bindir="$BIN" --extra-libs=-ldl --enable-gpl \
   --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora \
   --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree --enable-x11grab
make -j $JOBS
make install
make distclean

hash -r




	