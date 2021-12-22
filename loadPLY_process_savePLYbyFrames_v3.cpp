// Taken from https://github.com/ihmcrobotics/ihmc-open-robotics-software/blob/5f5345ea78f681c1ca815bb1539041b5d0ab54d0/ihmc-sensor-processing/csrc/ransac_schnabel/main.cpp
#define   _CRT_SECURE_NO_WARNINGS
#include <algorithm> // for max_element
#include <pcl/io/ply_io.h> // to load ply file and save ply files
#include <pcl/point_types.h> //use of pcl::PointXYZ Struct Reference
#include <pcl/registration/icp.h>
#include <pcl/console/time.h>   // TicToc
#include <pcl/common/common.h> //to compute minmax
using namespace std;
typedef pcl::PointXYZ PointT;
typedef pcl::PointCloud<PointT> PointCloudT;

#include <PointCloud.h>
#include <RansacShapeDetector.h>
#include <PlanePrimitiveShapeConstructor.h>
#include <PlanePrimitiveShape.h>
#include <CylinderPrimitiveShapeConstructor.h>
#include <SpherePrimitiveShapeConstructor.h>
#include <ConePrimitiveShapeConstructor.h>
#include <TorusPrimitiveShapeConstructor.h>
#include<iostream>
#include<string>
#include <fstream> 
#include<cmath>

PointCloud myLoadPC(string readPath);


int main()
{
	/*-----declaring parameters and paths to load point cloud-------*/
	int frame = 2;
	std::stringstream frame_str;
	frame_str << frame;
	string rootPath = "C:\\lib\\";
	string writePath = rootPath + "outputPlanes_t2\\";
			writePath = writePath  + "frame (" + frame_str.str() + ")" + "\\";
	std::string planeParametersFileName = writePath + "planeParameters.txt";
	std::string algorithmParametersFileName = writePath + "algorithmParameters.txt";
	string readPath = rootPath + "inputScenes\\" + "frame" + frame_str.str() + ".ply";
	/*-------declaring txt writing objects------*/
	ofstream out_txtFile(planeParametersFileName);
	ofstream out_txtFile2(algorithmParametersFileName);
	/*---------- loading PC from PLY  ------------*/
	PointCloud pc;
	pc=myLoadPC(readPath);
	/*----------parameterize the EfficientRANSAC algorithm-------------*/
	RansacShapeDetector::Options ransacOptions;
	ransacOptions.m_epsilon = .0132f; // set distance threshold to .01f of bounding box width
		// NOTE: Internally the distance threshold is taken as 3 * ransacOptions.m_epsilon!!!
	ransacOptions.m_bitmapEpsilon = .0132f;//sampling resolution of Hololens 2 for the distance used in lab
		// NOTE: This threshold is NOT multiplied internally!
	ransacOptions.m_normalThresh = .8f; // this is the cos of the maximal normal deviation
	ransacOptions.m_minSupport = 10; // this is the minimal numer of points required for a primitive
	ransacOptions.m_probability = .01f; // this is the "probability" with which a primitive is overlooked
	
	
	out_txtFile2 << "m_epsilon= " << ransacOptions.m_epsilon << "\n"
		<< "m_bitmapEpsilon= " << ransacOptions.m_bitmapEpsilon << "\n"
		<< "m_normalThresh= " << ransacOptions.m_normalThresh << "\n"
		<< "m_minSupport= " << ransacOptions.m_minSupport << "\n"
		<< "m_probability= " << ransacOptions.m_probability << "\n\n";

	out_txtFile2 << "Loaded PC from a PCL to EfficientRANSAC lib, with descriptors:" << "\n"
		<< "\t Size: " << pc.size() << endl
		<< "\t Scale is: " << pc.getScale() << endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< endl;

	/*----create objects for detector and for shapes------*/
	RansacShapeDetector detector(ransacOptions); // the detector object
	// set which primitives are to be detected by adding the respective constructors
	detector.Add(new PlanePrimitiveShapeConstructor());
	pcl::console::TicToc time;
	time.tic();
	MiscLib::Vector< std::pair< MiscLib::RefCountPtr< PrimitiveShape >, size_t > > shapes; // stores the detected shapes
	// begin the detection
	size_t remaining = detector.Detect(pc, 0, pc.size(), &shapes); // run detection
		// returns number of unassigned points
		// the array shapes is filled with pointers to the detected shapes
		// the second element per shapes gives the number of points assigned to that primitive (the support)
		// the points belonging to the first shape (shapes[0]) have been sorted to the end of pc,
		// i.e. into the range [ pc.size() - shapes[0].second, pc.size() )
		// the points of shape i are found in the range
		// [ pc.size() - \sum_{j=0..i} shapes[j].second, pc.size() - \sum_{j=0..i-1} shapes[j].second )
	
	std::cout << "processed in " << time.toc() << " ms\n"
			  << "remaining unassigned points " << remaining << std::endl;
	out_txtFile2 << "processed in " << time.toc() << " ms\n"
				<< "remaining unassigned points " << remaining << std::endl;

	/*--declare variables to track the findings during the detection---*/
	// Vector where each element represents the number of points by primitive; variable size
	Eigen::VectorXi NbPointsByPrimitive;
		
	//accumulators
	int accNbPointsByPrimitive, accNbPointsByPrimitive_pst;
	accNbPointsByPrimitive_pst = 0;
	//indexes
	int initIndex = 0;
	int endIndex = 0;
	std::string iterations;
	PrimitiveShape* shape;
	PlanePrimitiveShape* plane;
	Vec3f Normal;
	float Distance;
	std::string desc;
	for (int i = 0; i < shapes.size(); i++)
	{
		pcl::PointCloud<pcl::PointXYZ>::Ptr template_cloud_ptr(new pcl::PointCloud<pcl::PointXYZ>);
		/*----compute indexes (init/end) of inliers for each detected shape---*/
		NbPointsByPrimitive.resize(i + 1);
		for (int j = 0; j < i + 1; j++)
		{
			NbPointsByPrimitive(j) = shapes[j].second;
		}
		accNbPointsByPrimitive = NbPointsByPrimitive.sum();
		initIndex = pc.size() - accNbPointsByPrimitive - 1;
		endIndex = pc.size() - accNbPointsByPrimitive_pst - 1;
		/*---assembly PC for each set of inliers*/
		for (int k = initIndex; k < endIndex; k++)
		{
			pcl::PointXYZ basic_point;
			basic_point.x = *pc.at(k).pos;
			basic_point.y = *(pc.at(k).pos + 1);
			basic_point.z = *(pc.at(k).pos + 2);
			template_cloud_ptr->push_back(basic_point);
		}
		/*----save assembled PC using PLY format*/
		iterations=std::to_string(i);
		//iterations << i;
		std::string fileName = writePath + "Plane" + iterations + "A.ply";
		pcl::io::savePLYFileASCII(fileName, *template_cloud_ptr);
		std::cout << "shape " << i << " saved on disk as PLY file \n";
		/*---save model parameters associated with the stored inliers---*/
		shape = shapes[i].first;
		plane = static_cast<PlanePrimitiveShape*>(shape);
		Normal = plane->Internal().getNormal();//normal vector (A, B, C)
		Distance = plane->Internal().SignedDistToOrigin();//signed distance to orign (D)
		out_txtFile << Normal[0] << ", " << Normal[1] << ", " << Normal[2] << ", " << Distance  << std::endl;


/*---output descriptors*/
		//write parameters and run-time in descriptors.txt
		shapes[i].first->Description(&desc);
		cout << "\t consists of " << shapes[i].second
			<< " points, it is a " << desc << " (from index " << initIndex << " to " << endIndex << ")" << std::endl
			<< "\t parameters [A, B, C, D]: ["<< Normal[0] << ", " << Normal[1] << ", " << Normal[2] << ", " << Distance << "]" << std::endl
			<< "\t first point [x,y,z]: [" << *pc.at(initIndex).pos << ", " << *(pc.at(initIndex).pos + 1) << ", " << *(pc.at(initIndex).pos + 2) << "]"
			<< "\t end point [x,y,z]: [" << *pc.at(endIndex).pos << ", " << *(pc.at(endIndex).pos + 1) << ", " << *(pc.at(endIndex).pos + 2) << "]"
			<< std::endl;
			
		//update accumulated number of points by primitive
		accNbPointsByPrimitive_pst = accNbPointsByPrimitive;
	}
	//close txt writing objects
	out_txtFile.close();
	out_txtFile2.close();
}

//-----my functions definitions

PointCloud myLoadPC(string readPath)
{
	/*---------- loading PC from PLY  ------------*/
	//load with PCL
	pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc(new pcl::PointCloud<pcl::PointXYZ>); // https://pointclouds.org/documentation/structpcl_1_1_point_x_y_z.html
	if (pcl::io::loadPLYFile<pcl::PointXYZ>(readPath, *raw_pc) == -1) //* load the file from PLY
	{
		PCL_ERROR("Couldn't read PLY file at ... \n");
		std::cout << readPath;
		//return (-1);
		
	}
	//compute descriptors with PCL
	pcl::PointXYZ minPoint, maxPoint;
	pcl::getMinMax3D(*raw_pc, minPoint, maxPoint);

	cout << "Loaded PC from a PLY file, with descriptors:" << "\n"
		<< "\t Width: " << raw_pc->width
		<< "\t Height: " << raw_pc->height
		<< "\t Minimun Limits are [Xmin Ymin Zmin]: [ " << minPoint.x << ", " << minPoint.y << ", " << minPoint.z << "]" << endl
		<< "\t Maximum Limits are [Xmax Ymax Zmax]: [ " << maxPoint.x << ", " << maxPoint.y << ", " << maxPoint.z << "]" << endl
		<< "\t first point [x,y,z]: [" << raw_pc->points[0].x
		<< ", " << raw_pc->points[0].y << ", " << raw_pc->points[0].z << "]"
		<< endl;
	// load data to PointCloud object; the object from EfficientRansac Libraries 
	PointCloud pc;
	for (int i = 0; i < raw_pc->width; i++) {
		pc.push_back(Point(Vec3f(raw_pc->points[i].x, raw_pc->points[i].y, raw_pc->points[i].z)));
	}

	/*----compute/set additional descriptors on the raw point cloud-----*/
	pc.setBBox(Vec3f(minPoint.x, minPoint.y, minPoint.z), Vec3f(maxPoint.x, maxPoint.y, maxPoint.z));
	pc.calcNormals(3);

	cout << "Loaded PC from a PCL to EfficientRANSAC lib, with descriptors:" << "\n"
		<< "\t Size: " << pc.size() << endl
		<< "\t Scale is: " << pc.getScale() << endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< endl;
	cout << "Added " << pc.size() << " points" << std::endl;
	return pc;
}