Reproduce & compare three enhancement strategies
Author Jane Kozz

Visibility vs Noise Tradeoff
Global histogram equalization increases overall contrast but can also amplify noise in uniform regions. CLAHE improves local contrast while limiting noise using clipping, so it is more stable for medical images. Gamma correction adjusts brightness in a controlled way depending on the gamma value.

Measurement / Meaning Risk
In medical imaging strong contrast enhancement can change intensity relationships that may reflect real tissue properties. Over-enhancement may create artificial edges or exaggerate noise, which can affect visual interpretation or quantitative analysis. Therefore, enhancement should improve visibility without changing clinically meaningful information.

Segmentation comparison: Otsu vs K-means 
Failure-mode analysis

Otsu thresholding assumes that the image histogram has two clear intensity groups. In medical CT images this assumption may not hold because different tissues can have overlapping intensities, which may lead to incorrect segmentation.

K-means clustering can fail when clusters overlap or when initialization leads to unstable clustering results. It may also segment noise or small structures as separate clusters, which is why post-processing (removing small fragments) is useful.

Frequency-domain filtering equivalence experiment
Debug diary
Initially, the spatial and FFT results did not perfectly match, as shown by the difference image and the relatively large maxAbs and RMSE values. The mismatch was mainly caused by differences in padding and boundary handling between the spatial-domain filtering and the FFT-based implementation. In particular, incorrect alignment of the PSF and cropping after the inverse FFT can introduce discrepancies. After checking these steps (padding size, PSF centering, and cropping), the results became visually similar, although small differences remained near the image boundaries.

Short transform reflection: DFT vs DCT 
DFT vs DCT Reflection
For spectrum visualization, fftshift moves the DC (zero-frequency) component to the center of the spectrum, making low frequencies appear in the middle and high frequencies at the edges, which is easier to interpret. The log magnitude is used to compress the large dynamic range of the Fourier spectrum so that weaker frequency components become visible.

The DFT assumes periodic boundaries, which can create discontinuities at the image edges. In contrast, DCT-II uses cosine-only basis functions and can be interpreted as an even-symmetric extension of the signal beyond the boundaries. This reduces boundary artifacts and concentrates most signal energy in a few coefficients. Because of this energy compaction, DCT-II is widely used in JPEG compression, where many high-frequency coefficients can be removed with little visual impact.

