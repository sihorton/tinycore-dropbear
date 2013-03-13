export CFLAGS="-mtune=generic -Os -pipe"
export CXXFLAGS="-mtune=generic -Os -pipe"

BUILT=dropbear-2012.55
TMPDIR=out

if [ "$1" == "clean" ]; then
	rm -rf $TMPDIR
	exit 0
fi

cd "$BUILT/"

make clean
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1 strip

#create the outputs.
cd ../
rm -rf "$TMPDIR"
mkdir "$TMPDIR"
cd "$TMPDIR"

mkdir etc
cd etc
mkdir dropbear
cd dropbear
cp ../../../banner .
cd ../
mkdir init.d
ln -s /usr/local/etc/init.d/dropbear init.d/dropbear

cd ../
mkdir usr
cd usr
mkdir local
mkdir sbin
cp "../../$BUILT/dropbearmulti" sbin/dropbearmulti
mkdir bin
ln -s ../sbin/dropbearmulti bin/dropbear
ln -s ../sbin/dropbearmulti bin/dbclient
ln -s ../sbin/dropbearmulti bin/dropbearconvert
ln -s ../sbin/dropbearmulti bin/dropbearkey
ln -s ../sbin/dropbearmulti bin/scp
ln -s ../sbin/dropbearmulti bin/ssh
cd local
mkdir etc
cd etc
mkdir init.d
cp /usr/local/sbin/dropbear init.d/dropbear 
cd ../../../../

#######################
# Create extension    #
#######################
mkdir release
cd release
mksquashfs ../$TMPDIR dropbear.tcz
md5sum dropbear.tcz > dropbear.tcz.md5.txt
cp ../dropbear.tcz.info .
tar zcf dropbear.tar.gz dropbear.tcz dropbear.tcz.md5.txt
bcrypt dropbear.tar.gz <<END
tinycore
tinycore
END

