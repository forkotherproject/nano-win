#!/bin/sh
# Generate configure & friends for GIT users.

gnulib_url="git://git.sv.gnu.org/gnulib.git"
gnulib_hash="ac34618e85013bfec4650f02e8e79c5de6d80fb3"

modules="
	futimens
	getdelim
	getline
	getopt-gnu
	glob
	isblank
	iswblank
	lstat
	nl_langinfo
	regex
	sigaction
	snprintf-posix
	stdarg
	strcase
	strcasestr-simple
	strnlen
	sys_wait
	vsnprintf-posix
	wchar
	wctype-h
	wcwidth
"

# Make sure the local gnulib git repo is up-to-date.
if [ ! -d "gnulib" ]; then
	git clone --depth=1111 ${gnulib_url}
fi
cd gnulib >/dev/null || exit 1
curr_hash=$(git log -1 --format=%H)
if [ "${gnulib_hash}" != "${curr_hash}" ]; then
	git pull
	git checkout -f ${gnulib_hash}
fi
cd .. >/dev/null || exit 1

rm -rf lib
./gnulib/gnulib-tool \
	--import \
	${modules}

autoreconf -f -i -s
