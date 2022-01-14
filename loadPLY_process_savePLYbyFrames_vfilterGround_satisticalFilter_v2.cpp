// Taken from https://github.com/ihmcrobotics/ihmc-open-robotics-software/blob/5f5345ea78f681c1ca815bb1539041b5d0ab54d0/ihmc-sensor-processing/csrc/ransac_schnabel/main.cpp
#define   _CRT_SECURE_NO_WARNINGS
#include <algorithm> // for max_element
#include <pcl/io/ply_io.h> // to load ply file and save ply files
#include <pcl/point_types.h> //use of pcl::PointXYZ Struct Reference
#include <pcl/point_cloud.h> // for PointCloud
#include <pcl/console/time.h>   // TicToc
#include <pcl/common/common.h> //to compute minmax
#include <pcl/common/io.h> // for copyPointCloud
#include <pcl/sample_consensus/ransac.h>
#include <pcl/sample_consensus/sac_model_plane.h>

#include <pcl/filters/statistical_outlier_removal.h>
//using namespace std;
//using namespace pcl;

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

/*This function receives an aligned point cloud with ground (raw_pc), extracts the points
that conforms the ground and returns in the filtered_pc a point cloud without ground. Finally
returns the ground plane model in a VectorXf*/
Eigen::VectorXf extractGround(const pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc, 
	pcl::PointCloud<pcl::PointXYZ>::Ptr filtered_pc, 
	float DistanceTreshold);

/*efficient RANSAC */
void eRANSAC(RansacShapeDetector::Options ransacOptions, PointCloud& pc,
	MiscLib::Vector< std::pair< MiscLib::RefCountPtr< PrimitiveShape >, size_t > >& shapes,
	size_t& remaining)
{
	/*----create objects for detector and for shapes------*/
	RansacShapeDetector detector(ransacOptions); // the detector object
	// set which primitives are to be detected by adding the respective constructors
	detector.Add(new PlanePrimitiveShapeConstructor());
	remaining = detector.Detect(pc, 0, pc.size(), &shapes); // run detection
			// returns number of unassigned points
			// the array shapes is filled with pointers to the detected shapes
			// the second element per shapes gives the number of points assigned to that primitive (the support)
			// the points belonging to the first shape (shapes[0]) have been sorted to the end of pc,
			// i.e. into the range [ pc.size() - shapes[0].second, pc.size() )
			// the points of shape i are found in the range
			// [ pc.size() - \sum_{j=0..i} shapes[j].second, pc.size() - \sum_{j=0..i-1} shapes[j].second )
}
	
int main()
{
	/*-----declaring parameters and paths to load point cloud-------*/
	int frame = 2;
	std::stringstream frame_str;
	frame_str << frame;
	std::string rootPath = "C:\\lib\\";
	std::string writePath = rootPath + "outputPlanes_t7\\";
	writePath = writePath + "frame (" + frame_str.str() + ")" + "\\";
	std::string planeParametersFileName = writePath + "planeParameters.txt";
	std::string algorithmParametersFileName = writePath + "algorithmParameters.txt";
	std::string readPath = rootPath + "inputScenes\\" + "frame" + frame_str.str() + ".ply";
	/*-------declaring txt writing objects------*/
	std::ofstream out_txtFile(planeParametersFileName);
	std::ofstream out_txtFile2(algorithmParametersFileName);
	/*---------- loading raw_PC from PLY  ------------*/
	pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc(new pcl::PointCloud<pcl::PointXYZ>); // 
	if (pcl::io::loadPLYFile<pcl::PointXYZ>(readPath, *raw_pc) == -1) //* load the file from PLY
	{
		PCL_ERROR("Couldn't read PLY file at ... \n");
		std::cout << readPath;
		return (-1);
	}
	std::cout << "Loaded raw PC from a PLY file, with descriptors:" << "\n"
		<< "\t Width: " << raw_pc->width
		<< "\t Height: " << raw_pc->height
		<< "\t first point [x,y,z]: [" << raw_pc->points[0].x
		<< ", " << raw_pc->points[0].y << ", " << raw_pc->points[0].z << "]"
		<< std::endl;

	/*-----------extract ground and save in boxes_pc--------------*/
	Eigen::VectorXf modelCoeffs;
	pcl::PointCloud<pcl::PointXYZ>::Ptr boxes_pc(new pcl::PointCloud<pcl::PointXYZ>); // 
	double DistanceTreshold(0.1);
	modelCoeffs = extractGround(raw_pc, boxes_pc, DistanceTreshold);//source of the assertion error; this error was resolved by enabling vcpkg in project/properties
	
	out_txtFile2 << "Extract Ground stage descriptors: \n"
		<< "\t Distance Treshold: "<< DistanceTreshold << std::endl
		<< "\t Plane parameters [A, B, C, D]: [" << modelCoeffs[0]
		<< ", " << modelCoeffs[1] << ", " << modelCoeffs[2] << ", "
		<< modelCoeffs[3] << "]\n"
		<< "\tinput size of cloud: "<< raw_pc->width <<std::endl
		<< "\toutput size of cloud: " << boxes_pc->width << std::endl
		<< std::endl;
	
	std::cout << "PointCloud without ground has as descriptors:" << "\n"
		<< "\t Width: " << boxes_pc->width
		<< "\t Height: " << boxes_pc->height
		<< "\t first point [x,y,z]: [" << boxes_pc->points[0].x
		<< ", " << boxes_pc->points[0].y << ", " << boxes_pc->points[0].z << "]\n"
		<< "\t Plane parameters [A, B, C, D]: [" << modelCoeffs[0]
		<< ", " << modelCoeffs[1] << ", " << modelCoeffs[2] << ", "
		<< modelCoeffs[3] << "]"
		<< std::endl;
	/*-----------save cloud in PointCloud object from efficientRANSAC developers--------------*/
	//compute descriptors with PCL
	pcl::PointXYZ minPoint, maxPoint;
	pcl::getMinMax3D(*boxes_pc, minPoint, maxPoint);

	// load data to PointCloud object; the object from EfficientRansac Libraries 
	PointCloud pc;
	for (int i = 0; i < boxes_pc->width; i++) {
		pc.push_back(Point(Vec3f(boxes_pc->points[i].x, boxes_pc->points[i].y, boxes_pc->points[i].z)));
	}
	/*----compute/set additional descriptors on the raw point cloud-----*/
	pc.setBBox(Vec3f(minPoint.x, minPoint.y, minPoint.z), Vec3f(maxPoint.x, maxPoint.y, maxPoint.z));
	pc.calcNormals(3);

	std::cout << "PointCloud type object has as descriptors:" << "\n"
		<< "\t Size: " << pc.size() << std::endl
		<< "\t Scale is: " << pc.getScale() << std::endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< std::endl;

	/*execute efficient RANSAC*/
	//parameterize the EfficientRANSAC algorithm
	RansacShapeDetector::Options ransacOptions;
	ransacOptions.m_epsilon = .0132f; // set distance threshold to .01f of bounding box width
		// NOTE: Internally the distance threshold is taken as 3 * ransacOptions.m_epsilon!!!
	ransacOptions.m_bitmapEpsilon = .0132f;//sampling resolution of Hololens 2 for the distance used in lab
		// NOTE: This threshold is NOT multiplied internally!
	ransacOptions.m_normalThresh = .8f; // this is the cos of the maximal normal deviation
	ransacOptions.m_minSupport = 54; // this is the minimal number of points required for a primitive
	ransacOptions.m_probability = .01f; // this is the "probability" with which a primitive is overlooked

	size_t remaining(0);
	MiscLib::Vector< std::pair< MiscLib::RefCountPtr< PrimitiveShape >, size_t > > shapes;
	pcl::console::TicToc time;
	time.tic();
	eRANSAC(ransacOptions, pc, shapes, remaining);
	
	out_txtFile2 <<"Extract planes stage descriptors\n" 
		<<  "\t processed in " << time.toc() << " ms\n"
		<< "\t remaining unassigned points " << remaining << std::endl;

	out_txtFile2 << " \t m_epsilon= " << ransacOptions.m_epsilon << "\n"
		<< "\t m_bitmapEpsilon= " << ransacOptions.m_bitmapEpsilon << "\n"
		<< "\t m_normalThresh= " << ransacOptions.m_normalThresh << "\n"
		<< "\t m_minSupport= " << ransacOptions.m_minSupport << "\n"
		<< "\t m_probability= " << ransacOptions.m_probability << "\n\n";
	
	out_txtFile2 << "\t Cloud descriptors:" << "\n"
		<< "\t\t Size: " << pc.size() << std::endl
		<< "\t\t Scale is: " << pc.getScale() << std::endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< std::endl;

	//--Declare variables to track the findings during the detection
	Eigen::VectorXi NbPointsByPrimitive;// Vector where each element represents the number of points by primitive; variable size
	int accNbPointsByPrimitive, accNbPointsByPrimitive_pst(0);//accumulators
	int initIndex(0), endIndex(0);//indexes
	std::string iterations, desc;
	PrimitiveShape* shape;
	PlanePrimitiveShape* plane;
	Vec3f Normal;
	float Distance;
	pcl::StatisticalOutlierRemoval<pcl::PointXYZ> sor;//create filtering object
	sor.setMeanK(50);
	sor.setStddevMulThresh(1.0);
	
	//--save each detected plane in a ply file
	for (int i = 0; i < shapes.size(); i++)
	{
		pcl::PointCloud<pcl::PointXYZ>::Ptr template_cloud_ptr(new pcl::PointCloud<pcl::PointXYZ>);
		pcl::PointCloud<pcl::PointXYZ>::Ptr template_cloud_ptr_filtered(new pcl::PointCloud < pcl::PointXYZ>);
		//template_cloud_ptr_filtered->clear();
		//template_cloud_ptr->clear();
		
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
		for (int k = initIndex; k <= endIndex; k++)
		{
			pcl::PointXYZ basic_point;
			basic_point.x = *pc.at(k).pos;
			basic_point.y = *(pc.at(k).pos + 1);
			basic_point.z = *(pc.at(k).pos + 2);
			template_cloud_ptr->push_back(basic_point);
		}
		/*--- apply statistical filter to remove outliers on each plane */
		// config the filtering object
		sor.setInputCloud(template_cloud_ptr);
		sor.filter(*template_cloud_ptr_filtered);

		/*----save assembled PC using PLY format*/
		iterations = std::to_string(i);
		//iterations << i;
		std::string fileName = writePath + "Plane" + iterations + "A.ply";
		//pcl::io::savePLYFileASCII(fileName, *template_cloud_ptr);
		pcl::io::savePLYFileASCII(fileName, *template_cloud_ptr_filtered);
		std::cout << "shape " << i << " saved on disk as PLY file \n";
		/*---save model parameters associated with the stored inliers---*/
		shape = shapes[i].first;
		plane = static_cast<PlanePrimitiveShape*>(shape);
		Normal = plane->Internal().getNormal();//normal vector (A, B, C)
		Distance = plane->Internal().SignedDistToOrigin();//signed distance to orign (D)
		out_txtFile << Normal[0] << ", " << Normal[1] << ", " << Normal[2] << ", " << Distance << std::endl;

		/*---output descriptors*/
				//write parameters and run-time in descriptors.txt
		shapes[i].first->Description(&desc);
		std::cout << "\t consists of " << shapes[i].second
			<< " points, it is a " << desc << " (from index " << initIndex << " to " << endIndex << ")" << std::endl
			<< "\t parameters [A, B, C, D]: [" << Normal[0] << ", " << Normal[1] << ", " << Normal[2] << ", " << Distance << "]" << std::endl
			<< "\t first point [x,y,z]: [" << *pc.at(initIndex).pos << ", " << *(pc.at(initIndex).pos + 1) << ", " << *(pc.at(initIndex).pos + 2) << "]"
			<< "\t end point [x,y,z]: [" << *pc.at(endIndex).pos << ", " << *(pc.at(endIndex).pos + 1) << ", " << *(pc.at(endIndex).pos + 2) << "]"
			<< std::endl;

		//update accumulated number of points by primitive
		accNbPointsByPrimitive_pst = accNbPointsByPrimitive;

		//free memory
		template_cloud_ptr_filtered.reset();
		template_cloud_ptr.reset();
	}
	//close txt writing objects
	out_txtFile.close();
	out_txtFile2.close();
	return 0;

}

//-----my function definitions

/*This function receives an aligned point cloud with ground (raw_pc), extracts the points
that conforms the ground and returns in the filtered_pc a point cloud without ground. Finally
returns the ground plane model in a VectorXf*/
Eigen::VectorXf extractGround(const pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc, 
	pcl::PointCloud<pcl::PointXYZ>::Ptr filtered_pc, 
	float DistanceTreshold)
{
	/*---------EXTRACT GROUND PLANE (init)---------*/
	Eigen::VectorXf modelCoeffs;
	/*---2. Compute parameteres of the plane coplanar with ground----*/
	std::vector<int> inliersInt;
	//2.1 created RandomSampleConsensus object and compute the appropriated model
	pcl::SampleConsensusModelPlane<pcl::PointXYZ>::Ptr
		model_p(new pcl::SampleConsensusModelPlane<pcl::PointXYZ>(raw_pc));
	//2.2 generate model
	pcl::RandomSampleConsensus<pcl::PointXYZ> ransac(model_p);
	ransac.setDistanceThreshold(DistanceTreshold);
	ransac.computeModel();
	ransac.getInliers(inliersInt);
	int outliersSize = raw_pc->width - inliersInt.size();
	std::vector<int> outliers(outliersSize);

	//2.3 save obtained parameters in modelCoeffs

	ransac.getModelCoefficients(modelCoeffs);
	//2.4 compute outliers indexes from inlier indexes
	int m(0), k(0), currentInlier(0);
	currentInlier = inliersInt.at(k);//first target inlier
	//std::cout << "\t rawpc index \t\t outlierIndex \t\t inlierIndex \n";
	for (int i = 0; i < raw_pc->width - 1; i++)//fue necesario hacer una iteración menos para que el código no presentara error por sobrecarga: acceso a memoria que no le pertenece al vector
	{
		//std::cout << "\t "<< i << "\t\t" << m <<  "\t\t" << k << "\n";
		if (i == currentInlier && k < inliersInt.size() - 1)
		{//update the target inlier
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
	pcl::copyPointCloud(*raw_pc, outliers, *filtered_pc);
	//pcl::copyPointCloud(*raw_pc, inliersInt, *filtered_pc);
	//pcl::copyPointCloud(*raw_pc, *filtered_pc);
	/*---------EXTRACT GROUND PLANE (end)---------------------------*/
	return modelCoeffs;
}