Explainable AI Pipeline for Retinal Fundus Classification Using Vascular and Radiomic Biomarkers

Background: Retinal blood vessels provide a non-invasive view of the human microvasculature and may contain quantitative information relevant to ocular and systemic vascular health. This study developed an explainable machine-learning workflow based on vascular and radiomic features extracted from segmented retinal vessels.

Methods: Color fundus photographs from the publicly available ODIR-5K dataset were used. Images were cropped, resized to 768 × 768 pixels, normalized, and processed using a pretrained U-Net model to generate retinal vessel masks. Vascular biomarkers including vessel density, skeleton length, vessel width, branch points, and endpoints were extracted. Additional shape, first-order statistical, and gray-level co-occurrence matrix texture features were incorporated. A Random Forest classifier was trained using an 80:20 stratified train-test split to classify retinal images as Normal or Abnormal. An additional experiment using SMOTE was performed to evaluate the effect of class balancing.

Results: The model using vascular biomarkers alone achieved 77.09% accuracy, 93.71% recall, and an F1-score of 86.73%. After adding radiomic features, accuracy increased to 78.21%, recall to 97.20%, and F1-score to 87.70%. The model showed high sensitivity for abnormal retinal images but substantially lower performance for the minority Normal class. SMOTE improved minority-class detection but reduced overall performance.

Conclusion: Combining retinal vascular biomarkers with radiomic features improved classification performance compared with vascular features alone. The results demonstrate the feasibility of an interpretable retinal-image analysis pipeline and provide a methodological foundation for future studies investigating retinal vascular biomarkers for systemic and cardiovascular risk assessment

The long-term goal is to investigate retinal vascular biomarkers as non-invasive markers of systemic cardiovascular health, including:

- cardiovascular risk prediction from fundus/OCTA biomarkers;
- integration with de-identified clinical variables;
- longitudinal retinal imaging;
- non-invasive monitoring of vascular changes associated with sustained exercise and cardiovascular improvement.

Author:
Jane Kozz
M.S. Artificial Intelligence in Medicine
University of Louisville
