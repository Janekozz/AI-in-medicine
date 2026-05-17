Quantitative Analysis of Retinal Layer Shape Features Using OCT Images 
Author Jane Kozz 

1. Problem Description 
Optical Coherence Tomography OCT images provide cross-sectional views of the retina and 
allow us to study the structure of retinal layers. Quantitative analysis of these layers helps in 
understanding of  their geometric properties and detecting  possible abnormalities 
In this project the goal is to analyze retinal OCT image, using segmentation masks. I selected 
q5.png OCT image from the Case2 folder and computed three important geometric features of 
an upper retinal layer: Thickness, Curvature, Tortuosity

The segmentation mask provides the boundaries of retinal layers, which makes it possible to 
extract the layer of interest and compute these features. 
My analysis focuses on the upper boundary of the selected retinal layer 

2. Methodology 
The analysis was performed in three main steps: thickness estimation, curvature estimation, and 
tortuosity estimation.

2.1  Data Preparation 
OCT image and the corresponding segmentation mask were loaded in MATLAB. 
The segmentation mask contains labeled retinal layers. From the mask the boundaries of the 
selected layer were extracted. The boundaries were represented as curves consisting of 
ordered points. 
To verify the extraction process, the following visualizations were created: 
Original OCT image, binary mask and the segmentation overlay on the image 
Segmentation overlay on the image confirmed that the correct retinal layer was selected for 
analysis 

2.2 Thickness Estimation 
Thickness estimation was implemented using the Laplace-based method, which was shown in 
lectures. 
The inner and outer boundaries of the retinal layer were identified. A high potential value was 
assigned to one boundary and a low potential value was assigned to the other boundary 
Laplace equation was solved inside the retinal layer region. This was done using MATLAB 
functions such as regionfill 
After solving the Laplace equation the image gradients were computed (resulting in the 
components dxEpsi, dyEpsi). These gradients represent the direction of the potential field inside 
the layer 
Streamlines were generated following the gradient vector from the low-potential boundary to 
the high-potential boundary. Each streamline represent a path across the retinal layer 
The thickness map was computed by measuring the length of each streamline. 
The following outputs were obtained: 
Thickness statistics: 
Mean thickness: 139.75 pixels 
Standard deviation: 23.40 pixels 
Minimum thickness: 90.34 pixels 
Maximum thickness: 172.35 pixels 
A color-coded thickness map also was  generated to visualize thickness variation across the 
retinal layer
Thickness profile was generated to see how it aligns with the mean value of it

2.3. Curvature Estimation 
I implemented Curvature estimation using the upper  boundary curve of the selected retinal 
layer. 
The boundary points were extracted from the segmentation mask. These points were also 
ordered along the curve. 
I computed Curvature using the second-order approximation method from Lectures. This 
method uses derivatives of the boundary coordinates to estimate the curvature in each point. 
For each boundary point: -Normal vectors were computed -Local curvature values were calculated 
The curvature values were visualized along the boundary. 
The final result for this image: 
Mean curvature = 0.003208 
This value shows that the retinal boundary is relatively smooth with only mild curvature changes 
Curvature vs Position also was generated for better visualization

2.4 Tortuosity Estimation 
Tortuosity describes how much a curve deviates from a straight line. 
In this step the boundary was represented as a 1-pixel-wide curve. The start and end points of 
the boundary were identified. 
Two distances were computed: 
Geodesic distance: distance measured along the boundary curve 
Euclidean distance: straight-line distance between the same points 
Tortuosity was then computed using the formula: 
Tortuosity = Geodesic Distance / Euclidean Distance  
I generated Tortuosity map of upper boundary 
If the curve is perfectly straight -  tortuosity equals 1  
Larger values indicate more bending. 
Tortuosity was estimated using a fixed test distance of 50 pixels. 
The final results: 
Mean tortuosity = 1.069253 (average local tortuosity from the map) 
Geodesic distance = 986.12 pixels 
Euclidean distance = 890.16 pixels 
Tortuosity = 1.107795 (global) 
This value shows that the retinal boundary is slightly curved, but overall - smooth 

4. Results 
Besides the figures I shown upper I successfully computed all required features, using MATLAB

6. Discussion 
The results I got show that the retinal layer has moderate thickness variations along its length. 
The thickness ranges from approximately 90 pixels to 172 pixels. It shows that the layer is not 
uniform. 
The curvature analysis shows a very small mean curvature value. So  the retinal boundary is 
relatively smooth with only small local changes in shape. 
The tortuosity value is slightly greater than 1, which indicates that the boundary is curved but 
not too much. This is consistent with the natural shape of retinal layers in OCT image. 
Overall the implemented algorithms successfully extracted all required features of the retinal 
layer and provided quantitative measurements of the structure

