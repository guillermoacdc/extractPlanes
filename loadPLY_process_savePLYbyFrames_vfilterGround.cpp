// Taken from https://github.com/ihmcrobotics/ihmc-open-robotics-software/blob/5f5345ea78f681c1ca815bb1539041b5d0ab54d0/ihmc-sensor-processing/csrc/ransac_schnabel/main.cpp
#define   _CRT_SECURE_NO_WARNINGS
#include <algorithm> // for max_element
#include <pcl/io/ply_io.h> // to load ply file and save ply files
#include <pcl/point_types.h> //use of pcl::PointXYZ Struct Reference
#include <pcl/registration/icp.h>
#include <pcl/console/time.h>   // TicToc
#include <pcl/common/common.h> //to compute minmax
#include <pcl/sample_consensus/ransac.h>
#include <pcl/sample_consensus/sac_model_plane.h>
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

//pcl::PointCloud<pcl::PointXYZ>::Ptr
PointCloud myLoadPC(string readPath);
//pcl::PointCloud<pcl::PointXYZ>::Ptr extractGroundPlane(pcl::PointCloud<pcl::PointXYZ>::Ptr rawPC, float DistanceTreshold, Eigen::VectorXf modelCoeffs);
void extractGroundPlane(pcl::PointCloud<pcl::PointXYZ>::Ptr rawPC, pcl::PointCloud<pcl::PointXYZ>::Ptr final, float DistanceTreshold, Eigen::VectorXf modelCoeffs);
//this function receives a rawPC whose gravity vector is alligned with -z axis. Then applies a plane fitting process using an MSAC implementation. Afther this, computes a new pointcloud with the outliers of the plane fitting process. At the output you will find
//1. the pointCloud without ground; with pass by value
//2. the parameters of the plane model modelCoeffs; with pass by argument

int main()
{
	/*-----declaring parameters and paths to load point cloud-------*/
	int frame = 2;
	std::stringstream frame_str;
	frame_str << frame;
	string rootPath = "C:\\lib\\";
	string writePath = rootPath + "outputPlanes_t3\\";
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
	Eigen::VectorXf modelCoeffs;
	/*---------- loading PC from PLY  ------------*/
	//load with PCL
	pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc(new pcl::PointCloud<pcl::PointXYZ>); // 
	pcl::PointCloud<pcl::PointXYZ>::Ptr boxes_pc(new pcl::PointCloud<pcl::PointXYZ>); // 
	if (pcl::io::loadPLYFile<pcl::PointXYZ>(readPath, *raw_pc) == -1) //* load the file from PLY
	{
		PCL_ERROR("Couldn't read PLY file at ... \n");
		std::cout << readPath;
		//return (-1);
	}
	//boxes_pc = extractGroundPlane(raw_pc, 0.01, modelCoeffs);
	extractGroundPlane(raw_pc, boxes_pc, 0.01, modelCoeffs);
	//compute descriptors with PCL
	pcl::PointXYZ minPoint, maxPoint;
	pcl::getMinMax3D(*boxes_pc, minPoint, maxPoint);

	cout << "Loaded PC from a PLY file, with descriptors:" << "\n"
		<< "\t Width: " << boxes_pc->width
		<< "\t Height: " << boxes_pc->height
		<< "\t Minimun Limits are [Xmin Ymin Zmin]: [ " << minPoint.x << ", " << minPoint.y << ", " << minPoint.z << "]" << endl
		<< "\t Maximum Limits are [Xmax Ymax Zmax]: [ " << maxPoint.x << ", " << maxPoint.y << ", " << maxPoint.z << "]" << endl
		<< "\t first point [x,y,z]: [" << boxes_pc->points[0].x
		<< ", " << boxes_pc->points[0].y << ", " << boxes_pc->points[0].z << "]"
		<< endl;
	// load data to PointCloud object; the object from EfficientRansac Libraries 
	PointCloud pc;
	for (int i = 0; i < boxes_pc->width; i++) {
		pc.push_back(Point(Vec3f(boxes_pc->points[i].x, boxes_pc->points[i].y, boxes_pc->points[i].z)));
	}

	/*----compute/set additional descriptors on the raw point cloud-----*/
	pc.setBBox(Vec3f(minPoint.x, minPoint.y, minPoint.z), Vec3f(maxPoint.x, maxPoint.y, maxPoint.z));
	pc.calcNormals(3);

	cout << "PointCloud without ground have as descriptors:" << "\n"
		<< "\t Size: " << pc.size() << endl
		<< "\t Scale is: " << pc.getScale() << endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< "\t Plane parameters [A, B, C, D]: [" << modelCoeffs[0]
		<< ", " << modelCoeffs[1] << ", " << modelCoeffs[2] << ", "
		<< modelCoeffs[3] << "]" 
		<< endl;
			
	return pc;
}

//pcl::PointCloud<pcl::PointXYZ>::Ptr extractGroundPlane(pcl::PointCloud<pcl::PointXYZ>::Ptr rawPC, float DistanceTreshold, Eigen::VectorXf modelCoeffs)
void extractGroundPlane(pcl::PointCloud<pcl::PointXYZ>::Ptr rawPC, pcl::PointCloud<pcl::PointXYZ>::Ptr final, float DistanceTreshold, Eigen::VectorXf modelCoeffs)
{
	//pcl::PointCloud<pcl::PointXYZ>::Ptr final(new pcl::PointCloud<pcl::PointXYZ>);
	/*---2. Compute parameteres of the plane coplanar with ground----*/
	std::vector<int> inliersInt;
	//2.1 created RandomSampleConsensus object and compute the appropriated model
	pcl::SampleConsensusModelPlane<pcl::PointXYZ>::Ptr
		model_p(new pcl::SampleConsensusModelPlane<pcl::PointXYZ>(rawPC));
	//2.2 generate model
	pcl::RandomSampleConsensus<pcl::PointXYZ> ransac(model_p);
	ransac.setDistanceThreshold(DistanceTreshold);
	ransac.computeModel();
	ransac.getInliers(inliersInt);
	int outliersSize = rawPC->width - inliersInt.size();
	std::vector<int> outliers(outliersSize);
	//2.3 save obtained parameters in modelCoeffs
	
	ransac.getModelCoefficients(modelCoeffs);
	//2.4 compute outliers indexes from inlier indexes
	int m(0), k(0), currentInlier(0);
	currentInlier = inliersInt.at(k);
	for (int i = 0; i < rawPC->width - 1; i++)//fue necesario hacer una iteración menos para que el código no presentara error por sobrecarga: acceso a memoria que no le pertenece al vector
	{
		if (i == currentInlier)
		{
			k++;
			currentInlier = inliersInt.at(k);
		}
		else
		{
			outliers.at(m) = i;
			m++;
		}
	}
	// 2.5 copies all outliers of the model computed to another PointCloud
	//pcl::copyPointCloud(*rawPC, outliers, *final);
	pcl::copyPointCloud(*rawPC, inliersInt, *final);
	return;
	//2.6 return the output
	//return final;
}