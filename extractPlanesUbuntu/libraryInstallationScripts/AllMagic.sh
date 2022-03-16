#!/bin/bash
# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Reset the log files
printf '' > info-log.txt > debug-log.txt

# Tail the info logfile as a background process so the contents of the
# info logfile are output to stdout.
tail -f info-log.txt &

# Set an EXIT trap to ensure your background process is
# cleaned-up when the script exits
trap "pkill -P $$" EXIT

# Redirect both stdout and stderr to write to the debug logfile
exec 1>>debug-log.txt 2>>debug-log.txt

# Write to both info and debug
echo "Writing log...." | tee -a info-log.txt

# Write to info only. Remember to always append
echo "Start Build Libraries...." >> info-log.txt

usernamen=$(logname)
#path_home_user=$(eval echo ~$USER)
path_home_user="/home/${usernamen}/"
ubuntuVersion=$(lsb_release -s -r)
arcqui=$(uname -m)
numThreadsAvai=$(grep -c ^processor /proc/cpuinfo)
path_prefix=/usr/local/
path_prefix_boost="${path_prefix}"
path_prefix_vtk="${path_prefix}"
path_prefix_pcl="${path_prefix}"
path_run=$(echo $PWD)
#read -p "Please put the sudo password:" pass_sudo
pass_sudo=$1
if [ -z "$pass_sudo" ]
then
    echo "Please put the passwoord sudo." >> "${path_run}/info-log.txt"
    echo "Example to run Script:  ./AllMagic.sh your_pass_sudo" >> "${path_run}/info-log.txt"
    exit 1
else
    echo "Password sudo: " $pass_sudo
fi
echo "Path To install Library is: " $path_prefix >> "${path_run}/info-log.txt"
echo "Number cores PC: " $numThreadsAvai >> "${path_run}/info-log.txt"
echo "Ubuntu Version: " $ubuntuVersion >> "${path_run}/info-log.txt"
echo "Aquitechture: " $arcqui >> "${path_run}/info-log.txt"
sleep 2
path_src="${path_home_user}/magic/src/"
path_build="${path_home_user}/magic/build/"
path_resources="${path_home_user}/magic/resources/"
echo "» Creating Directory Tree Operations..." >> "${path_run}/info-log.txt"
echo $path_src >> "${path_run}/info-log.txt"
echo $path_build >> "${path_run}/info-log.txt"
echo $path_resources >> "${path_run}/info-log.txt"
echo $path_run >> "${path_run}/info-log.txt"
sleep 4
if [ -d "$path_prefix" ]; then
	echo "» Directory Install Exist" >> "${path_run}/info-log.txt"
else
	mkdir -p $path_prefix || true
	echo "» $path_prefix directory is created" >> "${path_run}/info-log.txt"
fi

if [ -d "$path_src" ]; then
	echo "» Directory src Exist" >> "${path_run}/info-log.txt"
else
	mkdir -p $path_src || true
	echo "» $path_src directory is created" >> "${path_run}/info-log.txt"
fi

if [ -d "$path_build" ]; then
	echo "» Directory build Exist" >> "${path_run}/info-log.txt"
else
	mkdir -p $path_build || true
	echo "» $path_build directory is created" >> "${path_run}/info-log.txt"
fi

if [ -d "$path_resources" ]; then
	echo "» Directory build Exist" >> "${path_run}/info-log.txt"
else
	mkdir -p $path_resources || true
	echo "» $path_resources directory is created" >> "${path_run}/info-log.txt"
fi

echo " ✅ Tree directories is fine" >> "${path_run}/info-log.txt"

cp cmake.desktop $path_resources || true
cp cmake-icon.png $path_resources || true
cp eclipse.desktop $path_resources || true


#echo "» Update and Upgrade System Ubuntu 18.04" >> "${path_run}/info-log.txt"
#echo "$pass_sudo" | sudo -S apt-get update
#echo "$pass_sudo" | sudo -S apt-get upgrade
echo " ✅ Success Upgrade and Update system" >> "${path_run}/info-log.txt"

echo "Installing ubuntu Things Development..."
echo "» Installing ubuntu Things Development..." >> "${path_run}/info-log.txt"
echo "$pass_sudo" | sudo -S apt-get install -y python-dev python3-dev
echo "$pass_sudo" | sudo -S apt-get install -y build-essential git libeigen3-dev libflann-dev libpcap-dev libopenni-dev libopenni2-dev libusb-1.0-0-dev libqhull-dev libgtest-dev
echo "$pass_sudo" | sudo -S apt-get install -y qtbase5-dev libqt5opengl5-dev qttools5-dev libqt5x11extras5-dev
echo "$pass_sudo" | sudo -S apt-get install -y qt5-default
echo "$pass_sudo" | sudo -S apt-get install -y libsuitesparse-dev libssl-dev
echo "$pass_sudo" | sudo -S apt-get install -y pkg-config checkinstall swig libpng-dev libpng++-dev libpnglite-dev zlib1g zlib1g-dbg zlib1g-dev pngtools libjpeg8 libjpeg8-dbg libjpeg8-dev libjpeg-progs libtiff5-dev libtiff5 libtiffxx5 libtiff-tools openexr libopenexr-dev libopenexr22 libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxine2-dev libxine2-bin libunicap2 libunicap2-dev libdc1394-22 libdc1394-22-dev libdc1394-utils libgstreamer1.0-0 libgstreamer1.0-dev gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-plugins-bad libgstreamer-plugins-base1.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev libvpx-dev yasm doxygen dh-make doxygen-latex graphviz

echo "$pass_sudo" | sudo -S apt-get install -y libx11-dev libxau-dev libxaw7-dev libxcb1-dev libxcomposite-dev libxcursor-dev libxdamage-dev libxdmcp-dev
echo "$pass_sudo" | sudo -S apt-get install -y libxext-dev libxfixes-dev libxfont-dev libxft-dev libxi-dev libxinerama-dev libxkbfile-dev libxmu-dev libxmuu-dev
echo "$pass_sudo" | sudo -S apt-get install -y libxpm-dev libxrandr-dev libxrender-dev libxres-dev libxss-dev libxt-dev libxtst-dev libxv-dev libxvmc-dev
echo "$pass_sudo" | sudo -S apt-get install -y libgl1-mesa-dev libglu1-mesa-dev mesa-utils
echo "$pass_sudo" | sudo -S apt-get install -y "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev

echo "$pass_sudo" | sudo -S apt-get install -y g++ autotools-dev libicu-dev libbz2-dev libcr-dev mpich libmpich-dev
echo "$pass_sudo" | sudo -S apt-get install -y openjdk-8-jdk wget
echo "$pass_sudo" | sudo -S apt-get install -y openjdk-17-jdk

echo "$pass_sudo" | sudo -S apt-get install -y libproj-dev
echo "$pass_sudo" | sudo -S apt-get install -y freeglut3-dev

echo "$pass_sudo" | sudo -S apt-get install -y subversion
echo "$pass_sudo" | sudo -S apt-get install -y swig
echo "$pass_sudo" | sudo -S apt-get install -y bison flex libtool
echo "$pass_sudo" | sudo -S apt-get install -y libcurl4-gnutls-dev liblcms2-dev liblcms2-utils
echo "$pass_sudo" | sudo -S apt-get install -y libspatialite-dev
echo "$pass_sudo" | sudo -S apt-get install -y libkml-dev libgeotiff-dev libdap-dev libgif-dev
echo "$pass_sudo" | sudo -S apt-get install -y libnetcdf-dev libxerces-c-dev libmysqlclient-dev
echo "$pass_sudo" | sudo -S apt-get install -y ogdi-bin libogdi3.2-dev
echo "$pass_sudo" | sudo -S apt-get install -y libpoppler-dev
echo "$pass_sudo" | sudo -S apt-get install -y libsqlite3-dev sqlite3

echo " ✅ Install package's development sucess" >> "${path_run}/info-log.txt"

echo "» Start Install Eclipse IDE" >> "${path_run}/info-log.txt"
cd $path_home_user
eclipse_tar=eclipse-dsl-2021-12-R-linux-gtk-x86_64.tar.gz
eclip_bin=/opt/eclipse/eclipse
if [ -f "$eclipse_tar" ]; then
    echo "» $eclipse_tar exists." >> "${path_run}/info-log.txt"
    rm $eclipse_tar
fi
if [ -f "$eclip_bin" ]; then
    echo "» $eclip_bin exists." >> "${path_run}/info-log.txt"
    sleep 3
else
    wget http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/2021-12/R/eclipse-dsl-2021-12-R-linux-gtk-x86_64.tar.gz
    echo "$pass_sudo" | sudo -S tar -xzf eclipse-dsl-2021-12-R-linux-gtk-x86_64.tar.gz -C /opt
    rm eclipse-dsl-2021-12-R-linux-gtk-x86_64.tar.gz
    cd $path_resources
    echo "$pass_sudo" | sudo -S desktop-file-install eclipse.desktop
fi

echo " ✅ Install Eclipse success" >> "${path_run}/info-log.txt"

cd $path_home_user
echo "» Start Install CMake" >> "${path_run}/info-log.txt"
path_dir_cmake="$path_home_user/cmake"
if [ -d "$path_dir_cmake" ]; then
	echo "» Directory cmake Exist" >> "${path_run}/info-log.txt"
else
	mkdir -p $path_dir_cmake;
	echo "» $path_dir_cmake directory is created" >> "${path_run}/info-log.txt"
fi
cd cmake
cmake_bin=/usr/local/bin/cmake
echo "$pass_sudo" | sudo -S apt remove -y --purge cmake
hash -r
if [ -f "$cmake_bin" ]; then
    echo "» $cmake_bin exists." >> "${path_run}/info-log.txt"
    cmake --version
    sleep 3
else
    wget https://github.com/Kitware/CMake/releases/download/v3.23.0-rc1/cmake-3.23.0-rc1.tar.gz
    tar -xzf cmake-3.23.0-rc1.tar.gz
    cd cmake-3.23.0-rc1
    ./bootstrap
    echo "$pass_sudo" | sudo -S make install
    cmake --version
    echo "$pass_sudo" | sudo -S ln -s /usr/local/bin/cmake /usr/bin/cmake
    echo "$pass_sudo" | sudo -S ldconfig
    sleep 3
    cd $path_home_user
    echo "$pass_sudo" | sudo -S rm -r cmake
fi

echo " ✅ Install CMake sucess" >> "${path_run}/info-log.txt"

echo "» Start Install Cmake GUI" >> "${path_run}/info-log.txt"
cd $path_home_user
cmake_tar=cmake-3.23.0-rc1-linux-x86_64.tar.gz
cmake_gui_bin=/opt/cmake-gui/bin/cmake
if [ -f "$cmake_tar" ]; then
    echo "» $cmake_tar exists." >> "${path_run}/info-log.txt"
    rm $cmake_tar
fi
if [ -f "$cmake_gui_bin" ]; then
    echo "» $cmake_gui_bin exists." >> "${path_run}/info-log.txt"
    sleep 3
else
    wget https://github.com/Kitware/CMake/releases/download/v3.23.0-rc1/cmake-3.23.0-rc1-linux-x86_64.tar.gz
    tar -xzf cmake-3.23.0-rc1-linux-x86_64.tar.gz
    echo "$pass_sudo" | sudo -S mv cmake-3.23.0-rc1-linux-x86_64 /opt/cmake-gui
    echo "$pass_sudo" | sudo -S ln -s /opt/cmake-gui/bin/cmake-gui /usr/bin/cmake-gui
    echo "$pass_sudo" | sudo -S ldconfig
    cd $path_resources
    echo "$pass_sudo" | sudo -S cp cmake-icon.png /opt/cmake-gui/
    echo "$pass_sudo" | sudo -S desktop-file-install cmake.desktop
    cd $path_home_user
    rm cmake-3.23.0-rc1-linux-x86_64.tar.gz
fi
echo " ✅ Install Cmake GUI success" >> "${path_run}/info-log.txt"
sleep 5

cd $path_src
echo "» Start Clonning Git's Libraries" >> "${path_run}/info-log.txt"
echo "Start Clonning Git's Libraries..."
sleep 3
echo "Clonning PROJ...."
echo "» Start Clonning PROJ" >> "${path_run}/info-log.txt"
git clone https://github.com/OSGeo/PROJ.git || true
cd PROJ
git checkout tags/6.3.2 -b 6.3.2 || true
cd ..
echo "End Clonning PROJ...."
echo "» End Clonning PROJ" >> "${path_run}/info-log.txt"

echo "Clonning PCL...."
echo "» Start Clonning PCL" >> "${path_run}/info-log.txt"
git clone https://github.com/PointCloudLibrary/pcl.git || true
cd pcl
git checkout tags/pcl-1.12.1 -b pcl-1.12.1 || true
cd ..
echo "End Clonning PCL...."
echo "» End Clonning PCL" >> "${path_run}/info-log.txt"

echo "Clonning VTK...."
echo "» Start Clonning VTK" >> "${path_run}/info-log.txt"
git clone https://github.com/Kitware/VTK.git || true
cd VTK
git checkout tags/v7.1.0 -b v7.1.0 || true
cd ..
echo "End Clonning VTK...."
echo "» End Clonning VTK" >> "${path_run}/info-log.txt"

echo "Clonning BOOST...."
echo "» Start Clonning BOOST" >> "${path_run}/info-log.txt"
wget https://sourceforge.net/projects/boost/files/boost/1.78.0/boost_1_78_0.tar.gz
tar -xzf boost_1_78_0.tar.gz
rm boost_1_78_0.tar.gz
echo "End Clonning Boost...."
echo "» End Clonning BOOST" >> "${path_run}/info-log.txt"

echo "Clonning PDAL...."
echo "» Start Clonning PDAL" >> "${path_run}/info-log.txt"
git clone https://github.com/PDAL/PDAL.git || true
cd PDAL
git checkout tags/2.3.0 -b 2.3.0 || true
cp -r "${path_run}/PDAL/vendor/lazperf" "${path_src}/PDAL/vendor/"
cd ..
echo "End Clonning PDAL...."
echo "» End Clonning PDAL" >> "${path_run}/info-log.txt"

echo "Clonning GDAL..."
echo "» Start Clonning GDAL" >> "${path_run}/info-log.txt"
git clone https://github.com/OSGeo/gdal.git || true
cd gdal
git checkout tags/v3.4.1 -b v3.4.1 || true
cd ..
echo "End Clonnning GDAL"
echo "» End Clonning GDAL" >> "${path_run}/info-log.txt"

echo "Clonning GEOS...."
echo "» Start Clonning GEOS" >> "${path_run}/info-log.txt"
wget http://download.osgeo.org/geos/geos-3.9.2.tar.bz2
tar xjf geos-3.9.2.tar.bz2
rm geos-3.9.2.tar.bz2
echo "End Clonning GEOS...."
echo "» End Clonning GEOS" >> "${path_run}/info-log.txt"

echo "Clonning SPATIALIATE...."
echo "» Start Clonning libspatialite" >> "${path_run}/info-log.txt"
wget http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.0.1.tar.gz
tar xzf libspatialite-5.0.1.tar.gz
rm libspatialite-5.0.1.tar.gz
echo "End Clonning SPATIALIATE...."
echo "» End Clonning libspatialite" >> "${path_run}/info-log.txt"

echo "Clonning rttopo..."
echo "» Start Clonning librttopo" >> "${path_run}/info-log.txt"
git clone https://git.osgeo.org/gitea/rttopo/librttopo.git || true
cd librttopo
git checkout tags/librttopo-1.1.0 -b librttopo-1.1.0 || true
cd ..
echo "End Clonnning rttopo"
echo "» End Clonning librttopo" >> "${path_run}/info-log.txt"

echo "Clonning RANSAC...."
echo "» Start Clonning RANSAC Eficcient PCSD" >> "${path_run}/info-log.txt"
git clone https://github.com/alessandro-gentilini/Efficient-RANSAC-for-Point-Cloud-Shape-Detection.git || true
mv Efficient-RANSAC-for-Point-Cloud-Shape-Detection ransac || true
cp "${path_run}/ransac/CMakeLists.txt" "${path_src}/ransac/"
cp "${path_run}/ransac/ransac.pc.in" "${path_src}/ransac/"
cp "${path_run}/ransac/RansacConfig.cmake.in" "${path_src}/ransac/"
cp "${path_run}/ransac/RansacConfigVersion.cmake.in" "${path_src}/ransac/"
echo "End Clonning RANSAC...."
echo "» End Clonning RANSAC Eficcient PCSD" >> "${path_run}/info-log.txt"
echo "End download libaries... :)"
echo " ✅ Cloning Libraries Finish" >> "${path_run}/info-log.txt"

echo " ✅ Building PROJ Start" >> "${path_run}/info-log.txt"
echo "Building PROJ..."
sleep 3
cd $path_src
cd PROJ
./autogen.sh
./configure
sleep 3
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
if [[ "$path_prefix" == "/usr/local/" ]];then
      echo "$pass_sudo" | sudo -S make install
else
      make install
fi
echo "$pass_sudo" | sudo -S ldconfig
cd ..
echo " ✅ Building PROJ End" >> "${path_run}/info-log.txt"

echo "Building Boost..."
echo " ✅ Building Boos Start" >> "${path_run}/info-log.txt"
sleep 3
cd boost_1_78_0
BOOST_INSTALL_PATH=$path_prefix_boost
typeBUILD=shared
chmod a+x bootstrap.sh
./bootstrap.sh --prefix="$BOOST_INSTALL_PATH"  --libdir="$BOOST_INSTALL_PATH"lib
tee -a project-config.jam << "EOF"
using mpi ;
EOF
if [[ "$path_prefix" == "/usr/local/" ]];then
	echo "$pass_sudo" | sudo -S ./b2 --with=all link="$typeBUILD" install
else
	./b2 --with=all link="$typeBUILD" install
fi
echo "Building Boost End."
echo "$pass_sudo" | sudo -S ldconfig
sleep 5
cd ..

echo " ✅ Building Boost End" >> "${path_run}/info-log.txt"

echo "Building VTK..."
echo " ✅ Building VTK Start" >> "${path_run}/info-log.txt"
cd $path_build
sleep 3
mkdir vtk || true
cd vtk
instPrefix=$path_prefix_vtk
cmake ../../src/VTK -DCMAKE_INSTALL_PREFIX="$instPrefix" -DVTK_USE_SYSTEM_JPEG=ON -DVTK_USE_SYSTEM_PNG=ON -DVTK_USE_SYSTEM_TIFF=ON -DVTK_USE_SYSTEM_TIFF=ON -DVTK_USE_SYSTEM_ZLIB=ON -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 -DModule_vtkGUISupportQt=ON  -DModule_vtkGUISupportQtOpenGL=ON -DModule_vtkGUISupportQtSQL=ON -DModule_vtkRenderingQt=ON -DModule_vtkViewsQt=ON -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON -DVTK_WRAP_PYTHON=OFF -DVTK_WRAP_JAVA=OFF -DVTK_USE_SYSTEM_LIBPROJ4=OFF -DModule_vtkIOMPIImage=ON -DModule_vtkIOMPIParallel=ON -DModule_vtkFiltersParallelDIY2=ON
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
if [[ "$path_prefix" == "/usr/local/" ]];then
      echo "$pass_sudo" | sudo -S make install
else
      make install
fi
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build VTK End"
sleep 3
cd ..
echo " ✅ Building VTK End" >> "${path_run}/info-log.txt"

echo "Building pcl..."
echo " ✅ Building PCL Start" >> "${path_run}/info-log.txt"
mkdir pcl || true
cd pcl
instPrefix=$path_prefix_pcl
cmake ../../src/pcl -DWITH_FZAPI=OFF -DWITH_PXCAPI=OFF -DCMAKE_INSTALL_PREFIX="$instPrefix" -DPCL_QT_VERSION=5 -DWITH_QT=ON
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
if [[ "$path_prefix" == "/usr/local/" ]];then
      echo "$pass_sudo" | sudo -S make install
else
      make install
fi
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build pcl End"
sleep 3
cd ..

echo " ✅ Building PCL End" >> "${path_run}/info-log.txt"

echo "Building geos"
echo " ✅ Building geos start" >> "${path_run}/info-log.txt"
mkdir osgeo || true
cd osgeo
cmake ../../src/geos-3.9.2
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build geos End"
sleep 3
cd ..
echo " ✅ Building geos End" >> "${path_run}/info-log.txt"

echo "Building rttopo"
echo " ✅ Building rttopo Start" >> "${path_run}/info-log.txt"
cd $path_src
cd librttopo
./autogen.sh
./configure
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build geos End"
sleep 3
cd ..

echo " ✅ Building rttopo End" >> "${path_run}/info-log.txt"

echo "Building libspatialate"
echo " ✅ Building libspatialite start" >> "${path_run}/info-log.txt"
cd $path_src
cd libspatialite-5.0.1
./configure --enable-freexl=no --disable-rttopo --disable-gcp --disable-proj
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build libspatialite End"
sleep 3
cd ..
echo " ✅ Building libspatialite End" >> "${path_run}/info-log.txt"

echo "Building GDAL"
echo " ✅ Building GDAL start" >> "${path_run}/info-log.txt"
cd $path_src
cd gdal/gdal
./autogen.sh
./configure --with-proj=/usr/local
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
/usr/local/bin/gdalinfo --version
echo "Build GDAL End"
sleep 3
echo " ✅ Building GDAL End" >> "${path_run}/info-log.txt"

echo "Building PDAL"
echo " ✅ Building PDAL start" >> "${path_run}/info-log.txt"
cd $path_build
mkdir PDAL || true
cd PDAL
cmake ../../src/PDAL -DCMAKE_EXE_LINKER_FLAGS="-lstdc++fs -lpthread -pthread" -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-lstdc++fs -lpthread -pthread" -DCMAKE_MODULE_LINKER_FLAGS="-lstdc++fs -lpthread -pthread" -DCMAKE_MODULE_LINKER_FLAGS_RELEASE="-lstdc++fs -lpthread -pthread" -DCMAKE_BUILD_TYPE="Release"
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo "Build PDAL End"
sleep 3
echo " ✅ Building PDAL End" >> "${path_run}/info-log.txt"

echo "Building RANSAC"
echo " ✅ Building RANSAC Eficcient start" >> "${path_run}/info-log.txt"
cd $path_build
mkdir ransac || true
cd ransac
cmake ../../src/ransac
sleep 4
echo "Start compiling...."
sleep 3
make
echo "End compling..."
echo "Start install..."
sleep 3
echo "$pass_sudo" | sudo -S make install
echo "$pass_sudo" | sudo -S ldconfig
echo "End install."
echo " ✅ Building RANSAC Efficient End" >> "${path_run}/info-log.txt"

#cd $path_home_user
#echo "Deleting Build Directory: "
#echo "$pass_sudo" | sudo -S rm -r "${path_home_user}/magic/"
echo " ✅ End Build Libraries" >> "${path_run}/info-log.txt"
