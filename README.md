# Box Tracking from Plane Segment Maps in RGBD SLAM Scenarios

This repository provides the implementation of the methods described in the project _"Sistema de seguimiento de pose de cajas para asistir operaciones manuales de cubicaje de mercancía: enfoque de integración de SLAM RGBD con conocimiento previo de secuencia de cubicaje, cantidad y tamaño de cajas en la escena"_. The system processes RGBD point clouds from a head-mounted camera, identifies plane segments, and tracks 3D positions and sizes of box-shaped objects over time.
The associated papers are
1. Camacho-Muñoz, G. A., Franco, J. C. M., Nope-Rodríguez, S. E.,
Loaiza-Correa, H., Gil-Parga, S., & Álvarez-Martínez, D. (2023). 6D-
ViCuT: Six degree-of-freedom visual cuboid tracking dataset for
manual packing of cargo in warehouses. Data in Brief, 109385.
https://doi.org/10.1016/j.dib.2023.109385

2.Camacho-Muñoz, G.A., Nope Rodríguez, S.E., Loaiza-Correa, H. et
al. Evaluation of the use of box size priors for 6D plane segment
tracking from point clouds with applications in cargo packing. J
Image Video Proc. 2024, 17 (2024). https://doi.org/10.1186/s13640-
024-00636-1

3. Camacho-Muñoz, G.A., Nope Rodríguez, S.E., Loaiza-Correa, H.
Evaluating 6D Box Tracking in Real-World Packing Operations: Effects
of Prior Knowledge and Camera Velocity.

## Features

- RGBD SLAM-based point cloud acquisition (HoloLens 2 compatible).
- Local and global plane segment extraction.
- Plane segment clustering and box reconstruction.
- Pose and size estimation with prior-based adjustment.
- Performance metrics computation (Precision, Recall, F1-score, error metrics).

## Demonstration

Watch the [demo video](https://www.youtube.com/watch?v=M03GApbzfx8) showing the pipeline execution step by step:

1. **Reading Input Point Cloud**
2. **Generation of Local Plane Segments**
3. **Generation of Map of Local Plane Segments**
4. **Generation of Global Plane Segment Map**
5. **Generation of Global Box Map**

<p align="center">
  <a href="https://www.youtube.com/watch?v=M03GApbzfx8">
    <img src="https://img.youtube.com/vi/M03GApbzfx8/hqdefault.jpg" alt="Watch the demo" width="480"/>
  </a>
</p>





