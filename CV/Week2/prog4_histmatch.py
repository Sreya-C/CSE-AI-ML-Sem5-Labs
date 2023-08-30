import cv2
import matplotlib.pyplot as plt
import numpy as np
from skimage import exposure

#Histogram Matching
src = cv2.imread('resources\\lenna.jpg')
ref = cv2.imread('resources\\reference.jpg')
multi = True if src.shape[-1] > 1 else False
matched = exposure.match_histograms(src, ref, multichannel=multi)
grayimgsrc = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
grayimgref = cv2.cvtColor(ref, cv2.COLOR_BGR2GRAY)
grayimgmat = cv2.cvtColor(matched, cv2.COLOR_BGR2GRAY)
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
