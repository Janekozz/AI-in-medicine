Comparison of Classical Machine Learning and Deep Learning on OCT images
Author Jane Kozz 

Part I — Classical Machine Learning 

1. Problem framing and dataset suitability  
I selected the medical “Retinal OCT images dataset” from online source: 
https://www.kaggle.com/datasets/paultimothymooney/kermany2018 
I created smaller dataset using 1000 OCT images for each 4 disease folders inside of “train” 
folder while “test” and “val” folders I kept untouched 
• The task is a multi-class classification problem where retinal OCT images must be classified 
into one of four disease categories: CNV, DME, DRUSEN, NORMAL 
The goal is to develop model capable of automatically identifying retinal diseases from medical 
images 
• The unit of analysis is one OCT image representing a retinal scan from a patient. Each 
image is treated as an independent data sample 
• The input After preprocessing the model uses  its pixel intensity values of resized image as 
numerical features.The raw input consists of grayscale OCT images 
Images were transformed into feature vectors using the following steps: 
• resize images to 128 × 128 pixels 
• convert to grayscale 
• normalize pixel values to [0,1] 
• flatten images into 1-dimensional feature vectors 
• the target/label 
The dataset contains four classes: -CNV – Choroidal Neovascularization -DME – Diabetic Macular Edema -DRUSEN – associated with age-related macular degeneration -NORMAL – Healthy retina 
• The baseline comparator helps evaluate whether more advanced models improve 
performance. A most frequent class classifier was used as a baseline 
Baseline results: Validation accuracy = 0.25    Test accuracy = 0.25 
This represents random performance for a balanced 4-class classification problem 
• The Retinal OCT dataset is suitable for this part because it is: - public biomedical dataset - it contains labeled medical images - it has a large number of samples, that supports machine learning training - it represents a real clinical task (retinal disease detection) - it allows both classical machine learning and deep learning approaches 
Risks  in the dataset:  
- Leakage may occur if images from the same patient appear in training and in test folders. 
The train/validation/test split should be unmixed to prevent leakage. Also  preprocessing steps 
such as scaling and PCA were fit only on the training data
- Confounding 
Image acquisition conditions (different devices or hospitals) can influence image appearance 
and potentially bias the model. OCT images may contain patterns unrelated to disease but 
related to imaging conditions 
- Class imbalance 
Some disease classes contain more images than others, which can bias the model and defend 
majority classes. Class imbalance is not present in our dataset  because each class contains 
the same number of samples 
- Label ambiguity 
Some retinal diseases exhibit similar visual characteristics, which may cause ambiguity in 
classification. 
- Unrealistic framing. Real clinical deployment would require larger datasets and external 
validation

2. Preprocessing and Evaluation Design 
Train / validation / test strategy 
The training set contained 4000 selected images (1000 per class), I limited the set to max 300 
images. So the training set contained 1200 selected images (300 per class), the validation set 
contained 32 images (8 per class), and the test set contained 968 images (242 per class). 
Training data was used to train models, validation data was used for model tuning, and test data 
was used for final evaluation 
Preprocessing steps 
Each OCT image was converted to grayscale, resized to 128 × 128 pixels, converted  to 
grayscale, pixel normalized to the range [0,1] and This produced 16384 features per image. It is 
extremely high so Principal Component Analysis (PCA) was applied to reduce dimensionality 
from 16384 features to 100 principal components. The first 100 components explain 
approximately 90.7% of the total variance. 
Leakage prevention 
To prevent information leakage, StandardScaler and PCA were fit on the training set only. The 
same fitted transformations were then applied to validation and test sets. 
Accuracy was used as a simple overall performance metric because the final selected dataset 
was class-balanced across classes in the reduced subset. In addition, a confusion matrix was 
used to analyze class-specific errors and identify which disease categories were confused most  
often. 
Evaluation metrics 
The following metrics were used: 
• accuracy 
• precision 
• recall 
• F1-score 
• confusion matrix

3. Baseline and model comparison 
A majority-class dummy classifier was used as the baseline. Since the classification task has 
four classes, baseline accuracy is approximately 25%, corresponding to random or 
most-frequent prediction under balanced class sampling. 
Three classical machine learning models were implemented: 
• Logistic Regression 
• Support Vector Machine (SVM) 
• Random Forest 
Among the evaluated classical machine learning models, SVM achieved the highest test 
accuracy (about 41.3%), while Random Forest achieved the highest validation accuracy (about 
36.6%). Logistic Regression performed close to baseline (35.6%), suggesting that the 
classification problem is not easily separated by a simple linear decision boundary after PCA 
compression

Confusion matrix: 
The confusion matrix shows that the SVM model performed best on the NORMAL class, while 
CNV, DME, and DRUSEN were more frequently confused with one another. This suggests that 
disease-related OCT patterns overlap and are difficult to separate using classical machine 
learning on flattened image features. 
  
4. Results and interpretation 
The results indicate that classical machine learning methods achieve moderate performance 
with a maximum accuracy of approximately 41%. Flattening images into feature vectors 
removes spatial information, which likely reduces classification performance. 
 
5. Error Analysis and Limitations 
The model failed mainly by confusing disease categories with one another, especially CNV, 
DME, and DRUSEN. This is visible in the confusion matrix, where off-diagonal entries remain 
high. One likely reason is that classical machine learning models operate on flattened pixel 
features and therefore do not explicitly capture the spatial structure of retinal lesions. Another 
limitation is the very small validation set (8 images per class), which may make validation 
estimates unstable. In addition, resizing images to 128 × 128 simplifies computation but may 
remove fine retinal details. 
The best-performing classical model was SVM, but overall test accuracy remained moderate. 
Therefore, the results justify the claim that classical machine learning can extract some 
diagnostic signal from OCT images, but they do not justify strong claims of clinical usefulness. A 
deep learning CNN is likely to perform better because it can learn spatial image patterns 
directly. 
In addition to overall accuracy, class-wise precision, recall, and F1-score were computed to 
better understand model performance for each retinal disease category. 
Model performance 
The baseline majority-class classifier achieved an accuracy of 25%, which corresponds to 
random guessing in a four-class classification problem. 
Among the evaluated classical machine learning models, the Support Vector Machine (SVM) 
achieved the highest test accuracy of approximately 41%. Random Forest performed similarly 
but slightly worse on the test set, while Logistic Regression performed close to baseline. 
This suggests that the relationship between features and labels is not well captured by a simple 
linear decision boundary. 
The classification report 
The classification report shows that the NORMAL class achieved the highest recall (0.63), 
indicating that healthy retinal images were easier for the model to identify. In contrast, CNV and 
DME had lower recall values, suggesting that these disease classes were often confused with 
other categories. This pattern is consistent with the confusion matrix, where disease categories 
show higher misclassification rates. 
Model 
Baseline 
Logistic Regression 
SVM 
Random Forest 
Validation 
Accuracy 
0.25 
0.25 
0.31 
0.41 
Test 
Accuracy 
0.25 
0.36 
0.41 
0.37 
SVM achieved the best test performance and was therefore selected for detailed error analysis. 
Error Analysis: 
The moderate accuracy suggests that classical machine learning models using flattened pixel 
features cannot fully capture the spatial structure of OCT images 
The pipeline is 
OCT image → Grayscale conversion → Resize 128×128 → Flatten (16384 features) → 
Standardization → PCA (100 components, 90.7% variance) → Baseline → Logistic Regression 
→ SVM → Random Forest → Evaluation → Confusion matrix → Classification report 
The moderate accuracy likely results from the limitations of the feature representation. 
Flattening images into pixel vectors removes spatial relationships between pixels. As a result, 
classical machine learning models may struggle to distinguish subtle retinal patterns. 
Classical machine learning approaches have limited ability to capture complex spatial structures 
in OCT images 
Where the model failed 
Errors occurred mainly between disease classes: 
-CNV vs DME -DRUSEN vs NORMAL 
Reasons for failure 
Possible causes include: 
• loss of spatial structure after flattening images 
• similarity between retinal disease patterns 
• limited dataset size 
Potential improvements 
Future improvements could include: 
• using convolutional neural networks 
• applying data augmentation 
• using transfer learning


Part II — Deep Learning  

I selected the same medical “Retinal OCT images dataset” from online source: 
https://www.kaggle.com/datasets/paultimothymooney/kermany2018 

1. Problem framing and dataset suitability 
The same OCT dataset was used for deep learning classification. 
Deep learning is appropriate because CNNs can automatically learn spatial features from image 
data

2. Model rationale and training design 
Model architecture 
A Convolutional Neural Network (CNN) was implemented using TensorFlow. 
Architecture: 
Input: 128 × 128 grayscale image 
Layers: 
Rescaling 
Conv2D (32 filters) 
MaxPooling 
Conv2D (64 filters) 
MaxPooling 
Conv2D (128 filters) 
MaxPooling 
Flatten 
Dense (128) 
Dropout 
Dense (4 output classes) 
Total parameters: 3,304,580 trainable parameters 
Preprocessing Images were: 
• resized to 128 × 128 
• normalized 
• loaded using TensorFlow datasets 
• batched for training 
Loss function  
The model used “Sparse categorical cross-entropy” It is appropriate for multi-class classification 
Optimizer: The Adam optimizer was used for training. 
Regularization Dropout was included in the dense layer to reduce overfitting

3. Results and interpretation 
Learning curves 
Interpretation: 
Training accuracy increases steadily while validation accuracy stabilizes around 0.81–0.84, 
indicating good learning performance with mild overfitting 
Final test performance 
Test accuracy: 76.6% 
Classification report: the table showing precision, recall, and F1-score 
Confusion matrix 
Interpretation:  
The confusion matrix shows that the CNN model correctly classifies most images across all 
classes, with the highest performance for the NORMAL class. Some confusion occurs between 
CNV, DME, and DRUSEN due to similarities in retinal structure patterns 
Overall results: 
* Test accuracy: ~0.77 
* Macro F1-score: ~0.77 
* Best class: NORMAL 
* Most confusion: between disease classes 
4. Error analysis and limitations 
Failure cases: Some DRUSEN images are misclassified as NORMAL or DME due to similar 
visual structures. 
Signs of overfitting 
Training accuracy approaches 96% while validation accuracy stabilizes around 81–84%, 
indicating mild overfitting 
Justification of architecture 
The CNN architecture effectively captures spatial patterns in retinal images 
Limitations 
Limitations include: 
• relatively small training dataset 
• limited validation set size 
• absence of data augmentation

Part III — Comparative Synthesis 

In this project I used one dataset of retinal OCT images for both the classical machine 
learning and deep learning parts because using the same dataset allowed me to see a fair 
comparison between the different models. It was a very interesting experience for me. This 
makes easier to see how much improvement deep learning provides compared to classical 
machine learning 
   One dataset was suitable for both parts because the OCT retinal dataset contains labeled 
medical images of four retinal conditions: CNV, DME, DRUSEN, and NORMAL. 
For the classical machine learning model the images were converted into numerical feature 
vectors by resizing them, converting them to grayscale, normalizing the pixel values, and 
flattening the images into vectors with 16,384 features. Then the  PCA was applied to reduce 
the dimensionality to 100 components with keeping about 90.7% of the variance 
For the deep learning part the original image structure was preserved and used directly by CNN. 
It automatically learns patterns from images.  
It works well for both because the dataset contains image data with clear labels. 

 Deep learning provided significantly better performance compared to classical machine 
learning models 
The best classical machine learning model was the Support Vector Machine  which achieved 
test accuracy about 41%. Logistic regression achieved about 36% and the random forest 
achieved about 37% 
In comparison the convolutional neural network achieved a test accuracy about 77% which is 
almost double of the classical models.performance  
This improvement happens because CNN models can learn spatial features from images but 
classical machine learning models rely on flattened image vectors that lose important spatial 
features 

The additional complexity of the CNN model was justified because it significantly improved 
the performance. 
The CNN model contains around 3.3 million trainable parameters, which makes it more complex 
than classical machine learning models. This complexity allows the model to learn detailed 
visual patterns in the retinal images 
The large improvement in accuracy from about 41% to 77% shows that the added complexity is 
worthwhile for this type of image classification problem. But the CNN requires more 
computational resources and longer training time

 Claims across the full project 
Based on the results it concluded: deep learning models perform better than classical machine 
learning models for image classification tasks, especially if data contains complex visual 
patterns 
The CNN model achieved higher accuracy and better precision and recall scores across all 
“disease classes” compared to the classical ML models. 
But my claims cannot be fully supported because the dataset I  used in this project is relatively 
small and the models were tested only on this dataset. The results may not generalize to other 
retinal datasets or real clinical environments without further validation 
