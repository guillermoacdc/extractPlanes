// Taken from https://github.com/ihmcrobotics/ihmc-open-robotics-software/blob/5f5345ea78f681c1ca815bb1539041b5d0ab54d0/ihmc-sensor-processing/csrc/ransac_schnabel/main.cpp
#define   _CRT_SECURE_NO_WARNINGS

#include <pcl/io/ply_io.h> // to load ply file and save ply files
#include <pcl/io/pcd_io.h> // to load ply file and save ply files
#include <pcl/point_types.h> //use of pcl::PointXYZ Struct Reference
#include <pcl/registration/icp.h>
#include <pcl/console/time.h>   // TicToc
using namespace std;
typedef pcl::PointXYZ PointT;
typedef pcl::PointCloud<PointT> PointCloudT;

#include <PointCloud.h>
#include <RansacShapeDetector.h>
#include <PlanePrimitiveShapeConstructor.h>
#include <CylinderPrimitiveShapeConstructor.h>
#include <SpherePrimitiveShapeConstructor.h>
#include <ConePrimitiveShapeConstructor.h>
#include <TorusPrimitiveShapeConstructor.h>
#include<iostream>
#include<cmath>




int main()
{
	int initIndex = 0;
	int endIndex = 0;

	string writePath = "C:\\lib\\outputPlanes_2019\\";
	//string readPath = "C:\\Users\\guill\\Documents\\Visual Studio 2019\\efficientRANSAC\\test1\\Efficient-RANSAC-for-Point-Cloud-Shape-Detection\\";
	/*---------- loading PC with PCL (PC_PCL) ------------*/
	pcl::PointCloud<pcl::PointXYZRGBA>::Ptr raw_pc(new pcl::PointCloud<pcl::PointXYZRGBA>);
    pcl::io::loadPCDFile ("C:/Users/guill/Documents/Visual Studio 2019/efficientRANSAC/test1/Efficient-RANSAC-for-Point-Cloud-Shape-Detection/scene_36_camera.pcd", *raw_pc);

	cout << "Loaded PC from a PLY file, with descriptors:" << "\n"
		<< "\t Width: " << raw_pc->width
		<< "\t Height: " << raw_pc->height
		<< "\t first point [x,y,z]: [" << raw_pc->points[initIndex].x
		<< ", " << raw_pc->points[initIndex].y << ", " << raw_pc->points[initIndex].z << "]"
		<< endl;
	/*loading PC from PCL into EfficientRansac Libraries (PC_ER)*/
	PointCloud pc;
	//  load point cloud from raw_pc
	for (int i = 0; i < raw_pc->width; i++) {
		pc.push_back(Point(Vec3f(raw_pc->points[i].x, raw_pc->points[i].y, raw_pc->points[i].z)));
	}
	cout << "Loaded PC from a PCL to EfficientRANSAC lib, with descriptors:" << "\n"
		<< "\t Size: " << pc.size()
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< endl;
	// set the bounding box in pc
	/*    "maxx": 2.84072,
		  "maxy": 0.14267,
		  "maxz": -1.21463,
		  "minx": -3.00608,
		  "miny": -1.51033,
		  "minz": -5.68384
*/
	//pc.setBBox(Vec3f(-3.00608, -1.51033, -5.68384), Vec3f(2.84072, 0.14267, -1.21463));//update to automatic computing of boundings
	pc.setBBox(Vec3f(-6, -6, -6), Vec3f(6, 6, 6));
	//void calcNormals( float radius, unsigned int kNN = 20, unsigned int maxTries = 100 );
	pc.calcNormals(3);
	std::cout << "Added " << pc.size() << " points" << std::endl;

	RansacShapeDetector::Options ransacOptions;
	ransacOptions.m_epsilon = .002f * pc.getScale(); // set distance threshold to .01f of bounding box width
		// NOTE: Internally the distance threshold is taken as 3 * ransacOptions.m_epsilon!!!
	ransacOptions.m_bitmapEpsilon = .0002f * pc.getScale(); // set bitmap resolution to .02f of bounding box width
		// NOTE: This threshold is NOT multiplied internally!
	ransacOptions.m_normalThresh = .9f; // this is the cos of the maximal normal deviation
	ransacOptions.m_minSupport = 10; // this is the minimal numer of points required for a primitive
	ransacOptions.m_probability = .001f; // this is the "probability" with which a primitive is overlooked

	RansacShapeDetector detector(ransacOptions); // the detector object

	// set which primitives are to be detected by adding the respective constructors
	detector.Add(new PlanePrimitiveShapeConstructor());

	pcl::console::TicToc time;
	time.tic();
	MiscLib::Vector< std::pair< MiscLib::RefCountPtr< PrimitiveShape >, size_t > > shapes; // stores the detected shapes
	size_t remaining = detector.Detect(pc, 0, pc.size(), &shapes); // run detection
		// returns number of unassigned points
		// the array shapes is filled with pointers to the detected shapes
		// the second element per shapes gives the number of points assigned to that primitive (the support)
		// the points belonging to the first shape (shapes[0]) have been sorted to the end of pc,
		// i.e. into the range [ pc.size() - shapes[0].second, pc.size() )
		// the points of shape i are found in the range
		// [ pc.size() - \sum_{j=0..i} shapes[j].second, pc.size() - \sum_{j=0..i-1} shapes[j].second )
	std::cout << "processed in " << time.toc() << " ms\n";
	std::cout << "remaining unassigned points " << remaining << std::endl;

	Eigen::VectorXi NbPointsByPrimitive;
	int accNbPointsByPrimitive, accNbPointsByPrimitive_pst;
	accNbPointsByPrimitive_pst = 0;
	for (int i = 0; i < shapes.size(); i++)
	{
		pcl::PointCloud<pcl::PointXYZ>::Ptr template_cloud_ptr(new pcl::PointCloud<pcl::PointXYZ>);
		/*----compute indexes---*/
		NbPointsByPrimitive.resize(i + 1);
		for (int j = 0; j < i + 1; j++)
		{
			NbPointsByPrimitive(j) = shapes[j].second;
		}
		accNbPointsByPrimitive = NbPointsByPrimitive.sum();
		initIndex = pc.size() - accNbPointsByPrimitive - 1;
		endIndex = pc.size() - accNbPointsByPrimitive_pst - 1;
		/*---assembly PC for each shape*/
		for (int k = initIndex; k < endIndex; k++)
		{
			pcl::PointXYZ basic_point;
			basic_point.x = *pc.at(k).pos;
			basic_point.y = *(pc.at(k).pos + 1);
			basic_point.z = *(pc.at(k).pos + 2);

			template_cloud_ptr->push_back(basic_point);
		}
		/*----save assembled PC using PLY format*/
		std::stringstream iterations;
		iterations << i;
		std::string fileName = writePath + "Plane" + iterations.str() + "A.ply";
		
		pcl::io::savePLYFileASCII(fileName, *template_cloud_ptr);
//		pcl::io::savePLYFileBinary(fileName, *template_cloud_ptr);
		std::cout << "shape " << i << " saved on disk as PLY file \n";
		/*---output descriptors*/
		std::string desc;
		shapes[i].first->Description(&desc);
		std::cout << "\t consists of " << shapes[i].second
			<< " points, it is a " << desc << " (from index " << initIndex << " to " << endIndex << ")" << std::endl
			<< "\t first point [x,y,z]: [" << *pc.at(initIndex).pos << ", " << *(pc.at(initIndex).pos + 1) << ", " << *(pc.at(initIndex).pos + 2) << "]"
			<< "\t end point [x,y,z]: [" << *pc.at(endIndex).pos << ", " << *(pc.at(endIndex).pos + 1) << ", " << *(pc.at(endIndex).pos + 2) << "]"
			<< std::endl;
		accNbPointsByPrimitive_pst = accNbPointsByPrimitive;
	}

}


