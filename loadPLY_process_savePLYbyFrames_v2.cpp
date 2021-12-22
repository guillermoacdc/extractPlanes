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
#include <fstream> 
#include<cmath>




int main()
{

	int frame = 9;
	std::stringstream frame_str;
	frame_str << frame;

	string rootPath = "C:\\lib\\";
	string writePath = rootPath + "outputPlanes_t1\\";
			writePath = writePath  + "frame (" + frame_str.str() + ")" + "\\";
	std::string planeParametersFileName = writePath + "planeParameters.txt";
	std::string algorithmParametersFileName = writePath + "algorithmParameters.txt";
	ofstream out_txtFile(planeParametersFileName);
	ofstream out_txtFile2(algorithmParametersFileName);
	string readPath = rootPath + "inputScenes\\" + "frame" + frame_str.str() + ".ply";

	
	/*---------- loading PC with PCL (PC_PCL) ------------*/
	pcl::PointCloud<pcl::PointXYZ>::Ptr raw_pc(new pcl::PointCloud<pcl::PointXYZ>); // https://pointclouds.org/documentation/structpcl_1_1_point_x_y_z.html
	if (pcl::io::loadPLYFile<pcl::PointXYZ>(readPath, *raw_pc) == -1) //* load the file from PLY
	{
		PCL_ERROR("Couldn't read PLY file at ... \n");
		std::cout << readPath;
		return (-1);
	}

	pcl::PointXYZ minPoint, maxPoint;
	pcl::getMinMax3D(*raw_pc, minPoint, maxPoint);
	
	cout << "Loaded PC from a PLY file, with descriptors:" << "\n"
		<< "\t Width: " << raw_pc->width
		<< "\t Height: " << raw_pc->height
		<< "\t Minimun Limits are [Xmin Ymin Zmin]: [ " << minPoint.x << ", " << minPoint.y << ", " << minPoint.z <<"]" << endl
		<< "\t Maximum Limits are [Xmax Ymax Zmax]: [ " << maxPoint.x << ", " << maxPoint.y << ", " << maxPoint.z <<"]" << endl
		<< "\t first point [x,y,z]: [" << raw_pc->points[0].x
		<< ", " << raw_pc->points[0].y << ", " << raw_pc->points[0].z << "]"
		<< endl;

	/*loading PC from PCL into EfficientRansac Libraries (PC_ER)*/
	PointCloud pc;
	//  load point cloud from raw_pc
	for (int i = 0; i < raw_pc->width; i++) {
		pc.push_back(Point(Vec3f(raw_pc->points[i].x, raw_pc->points[i].y, raw_pc->points[i].z)));
	}

	

	
	//pc.setBBox(Vec3f(-6, -6, -6), Vec3f(6, 6, 6));
	pc.setBBox(Vec3f(minPoint.x, minPoint.y, minPoint.z), Vec3f(maxPoint.x, maxPoint.y, maxPoint.z));
	//void calcNormals( float radius, unsigned int kNN = 20, unsigned int maxTries = 100 );
	pc.calcNormals(3);

	cout << "Loaded PC from a PCL to EfficientRANSAC lib, with descriptors:" << "\n"
		<< "\t Size: " << pc.size() << endl
		<< "\t Scale is: " << pc.getScale() << endl
		<< "\t first point [x,y,z]: [" << *pc.at(0).pos << ", " << *(pc.at(0).pos + 1) << ", " << *(pc.at(0).pos + 2) << "]"
		<< endl;
		
	std::cout << "Added " << pc.size() << " points" << std::endl;


	RansacShapeDetector::Options ransacOptions;
	ransacOptions.m_epsilon = .0132f; // set distance threshold to .01f of bounding box width
		// NOTE: Internally the distance threshold is taken as 3 * ransacOptions.m_epsilon!!!
	ransacOptions.m_bitmapEpsilon = .0132f;//sampling resolution of Hololens 2 for the distance used in lab
		// NOTE: This threshold is NOT multiplied internally!
	ransacOptions.m_normalThresh = .8f; // this is the cos of the maximal normal deviation
	ransacOptions.m_minSupport = 10; // this is the minimal numer of points required for a primitive
	ransacOptions.m_probability = .01f; // this is the "probability" with which a primitive is overlooked
	
	/*ransacOptions.m_epsilon = .002f * pc.getScale(); // set distance threshold to .01f of bounding box width
		// NOTE: Internally the distance threshold is taken as 3 * ransacOptions.m_epsilon!!!
	//ransacOptions.m_bitmapEpsilon = .002f * pc.getScale(); // set bitmap resolution to .02f of bounding box width
	ransacOptions.m_bitmapEpsilon = .01f;//sampling resolution of Hololens 2 for the distance used in lab
		// NOTE: This threshold is NOT multiplied internally!
	ransacOptions.m_normalThresh = .9f; // this is the cos of the maximal normal deviation
	ransacOptions.m_minSupport = 20; // this is the minimal numer of points required for a primitive
	ransacOptions.m_probability = .01f; // this is the "probability" with which a primitive is overlooked
	*/
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
	std::cout << "processed in " << time.toc() << " ms\n"
			  << "remaining unassigned points " << remaining << std::endl;

	out_txtFile2 << "processed in " << time.toc() << " ms\n"
				<< "remaining unassigned points " << remaining << std::endl;

	Eigen::VectorXi NbPointsByPrimitive;
	Vec3f myNormal;
	int accNbPointsByPrimitive, accNbPointsByPrimitive_pst;
	accNbPointsByPrimitive_pst = 0;
	int initIndex = 0;
	int endIndex = 0;
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
		std::cout << "shape " << i << " saved on disk as PLY file \n";
		/*---save model parameters---*/
		PrimitiveShape* shape = shapes[i].first;
		const PlanePrimitiveShape* plane = static_cast<const PlanePrimitiveShape*>(shape);
		Vec3f N = plane->Internal().getNormal();//normal vector (A, B, C)
		float D = plane->Internal().SignedDistToOrigin();//signed distance to orign (D)
		out_txtFile << N[0] << ", " << N[1] << ", " << N[2] << ", " << D  << std::endl;




/*---output descriptors*/
		//write parameters and run-time in descriptors.txt

		std::string desc;

		shapes[i].first->Description(&desc);

		std::cout << "\t consists of " << shapes[i].second
			<< " points, it is a " << desc << " (from index " << initIndex << " to " << endIndex << ")" << std::endl
			<< "\t parameters [A, B, C, D]: ["<< N[0] << ", " << N[1] << ", " << N[2] << ", " << D << "]" << std::endl
			<< "\t first point [x,y,z]: [" << *pc.at(initIndex).pos << ", " << *(pc.at(initIndex).pos + 1) << ", " << *(pc.at(initIndex).pos + 2) << "]"
			<< "\t end point [x,y,z]: [" << *pc.at(endIndex).pos << ", " << *(pc.at(endIndex).pos + 1) << ", " << *(pc.at(endIndex).pos + 2) << "]"
			<< std::endl;
		
		/*out_txtFile2 << "\t consists of " << shapes[i].second
			<< " points, it is a " << desc << " (from index " << initIndex << " to " << endIndex << ")" << std::endl
			<< "\t parameters [A, B, C, D]: [" << N[0] << ", " << N[1] << ", " << N[2] << ", " << D << "]" << std::endl
			<< "\t first point [x,y,z]: [" << *pc.at(initIndex).pos << ", " << *(pc.at(initIndex).pos + 1) << ", " << *(pc.at(initIndex).pos + 2) << "]"
			<< "\t end point [x,y,z]: [" << *pc.at(endIndex).pos << ", " << *(pc.at(endIndex).pos + 1) << ", " << *(pc.at(endIndex).pos + 2) << "]"
			<< std::endl;*/

		//update accumulated number of points by primitive
		accNbPointsByPrimitive_pst = accNbPointsByPrimitive;
	}
	out_txtFile.close();
	out_txtFile2.close();
}


