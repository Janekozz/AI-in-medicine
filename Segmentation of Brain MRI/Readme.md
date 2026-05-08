Multilevel Threshold-Based Segmentation of Brain MRI  
Author Jane Kozz 
Problem:  
To segment 3D brain MRI volume to 4 intensity based regions (gray matter, white matter, CSF 
and others) using multilevel thresholding in comparison to Otsu’s thresholding method 
Method: MultiIterative Global Thresholding and Otsu’s Thresholding Methods 
Results: 
I got right outputs in the thresholding: 
Both methods produce 3 thresholds, 4 segmentation regions. The values are very close 
between methods: - 41 vs 43 - 120 vs 122 - 199 vs 200 
The histogram now shows three thresholds for both methods. The iterative method produces 
slightly different threshold values compared to Otsu’s method showing how intensity classes are 
separated: 
Discussion: 
Both methods separated the MRI intensity range into similar regions with only small differences 
because of different methods of thresholding. A visual comparison shows that the iterative 
thresholding method separates major intensity regions. And it does match the ground truth 
approximately (not exactly) 
The dataset includes ground truth segmentation (labeled).  
I added visualisation for one slide to see the segmentation. 
For the slices with segmentation I added colormap “jet” and I got colored segmentation: 
The iterative thresholding method segmented the MRI into 4 regions 
The segmentation shows similar structure to the ground truth in separating 4 regions: gray 
matter, white matter, CSF and other. Some differences appear near boundaries (due to intensity 
overlap). In comparison the Otsu’s thresholding method shows very close results to iterative 
thresholding method 

