# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        export CC=clang
        export CXX=clang++
        export BUILD_PREFIX="${BUILD_PREFIX:-/usr/local}"
        # export CFLAGS="-fPIC -O3 -arch i386 -arch x86_64 -g -DNDEBUG -mmacosx-version-min=10.6"
        brew update
        brew install swig # automake
        brew install gmp
    else
	
	yum install -y pcre-devel gmp-devel
		# yum install automake
	mkdir -p $HOME/swiglpk_build
        curl -O -L http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz
        tar xzf swig-3.0.10.tar.gz
        (cd swig-3.0.10 \
				&& ./configure --prefix=$HOME/swiglpk_build \
				&& make \
				&& make install)
	fi

	pip3 install requests
	export NEW_GLPK_VERSION=$(python3 scripts/find_newest_glpk_release.py)
	echo "Downloading http://ftp.gnu.org/gnu/glpk/glpk-$NEW_GLPK_VERSION.tar.gz"
    curl -O "http://ftp.gnu.org/gnu/glpk/glpk-$NEW_GLPK_VERSION.tar.gz"
    tar xzf "glpk-$NEW_GLPK_VERSION.tar.gz"
    (cd "glpk-$NEW_GLPK_VERSION" \
            && ./configure --disable-reentrant --prefix=$HOME/swiglpk_build --with-gmp\
            && make \
            && make install) || cat "glpk-$NEW_GLPK_VERSION/config.log"
    echo "Installed to $BUILD_PREFIX"
    ls -ls .
}
