import cv2
import matplotlib.pyplot as plt
import numpy as np
from skimage import exposure
img = cv2.imread("dark.jpg",1)
cv2.imshow("Original",img)

#Log Transform
c = 255/(np.log(1+np.max(img)))
log_transformed = c * np.log(1 + img)
log_transformed = np.array(log_transformed,dtype = 'uint8')
cv2.imshow("Log Transform",log_transformed)
cv2.imwrite('Log_Transformed.jpg',log_transformed)

# Gamma Correction
for gamma in [0.2,0.5,1.2,2.5]:
    gamma_corrected = np.array(255*(img/255)**gamma,dtype = 'uint8')
    cv2.imshow("Gamma Correction" + str(gamma),gamma_corrected)
    cv2.imwrite("GammaCorrected" + str(gamma) + ".jpg",gamma_corrected)


#Histogram Equalization
grayimg = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
cv2.imshow("Gray Image",grayimg)
equ = cv2.equalizeHist(grayimg)
cv2.imshow("Histogram Equalized",equ)

plt.hist(grayimg.flatten(),256,[0,256], color = 'r')
plt.xlim([0,256])
plt.hist(equ.flatten(),256,[0,256], color = 'g')
plt.xlim([0,256])
plt.legend(('Original','Equalized Histogram'), loc = 'upper left')
plt.show()

#Histogram Matching

src = cv2.imread('lenna.jpg')
ref = cv2.imread('reference.jpg')
multi = True if src.shape[-1] > 1 else False
matched = exposure.match_histograms(src, ref, multichannel=multi)
grayimgsrc = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
grayimgref = cv2.cvtColor(ref, cv2.COLOR_BGR2GRAY)
grayimgmat = cv2.cvtColor(ref, cv2.COLOR_BGR2GRAY)
plt.hist(grayimgsrc.flatten(),256,[0,256], color = 'r')
plt.xlim([0,256])
plt.hist(grayimgref.flatten(),256,[0,256], color = 'g')
plt.xlim([0,256])
plt.hist(grayimgmat.flatten(),256,[0,256], color = 'b')
plt.xlim([0,256])
plt.legend(('Image','Reference','Matched'), loc = 'upper left')
plt.show()

cv2.imshow("Source", src)
cv2.imshow("Reference", ref)
cv2.imshow("Matched", matched)

cv2.waitKey()
cv2.destroyAllWindows()

