
# Ubuntu packages
VERSION="$1"
sudo apt update
sudo apt install -y vim build-essential python3 python3-dev

# Compile OpenFST with Python extension for Python 3 and Install
wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-$VERSION.tar.gz
tar xzvf openfst-$VERSION.tar.gz
cd openfst-$VERSION/

sudo pip3 install cython
pushd ./src/extensions/python/
mv pywrapfst.cc pywrapfst.cc.py2bkup
vim -c ":1755" -c ':s/"write/b"write' -c ":wq" pywrapfst.pyx
cython -f --cplus -3 pywrapfst.pyx -o pywrapfst.cc
popd

./configure --enable-far --enable-python

vim -c ":%s/PYTHON_CPPFLAGS = -I\/usr\/include\/python2.7/PYTHON_CPPFLAGS = -I\/usr\/include\/python3.5m/" -c ":%s/PYTHON_LDFLAGS = -L\/usr\/lib\/python2.7 -lpython2.7/PYTHON_LDFLAGS = -L\/usr\/include\/python3.5/" -c ":%s/PYTHON_SITE_PKG = \/usr\/lib\/python2.7/PYTHON_SITE_PKG = \/usr\/local\/lib\/python3.5\/site-packages/" -c ":%s/PYTHON_VERSION = 2.7/PYTHON_VERSION = 3.5/" -c ":%s/lib\/python2.7\/dist-packages/lib\/python3.5\/dist-packages/" -c ":wq" ./src/extensions/python/Makefile

make
sudo make install
echo 'export LD_LIBRARY_PATH=/usr/local/lib/fst/:/usr/local/lib/:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
