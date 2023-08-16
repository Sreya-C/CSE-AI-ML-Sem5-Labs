import cv2
import matplotlib.pyplot as plt
import numpy as np
from skimage import exposure
img = cv2.imread("resources\\dark.jpg",1)
cv2.imshow("Original",img)

# Gamma Correction
for gamma in [0.2,0.5,1.2,2.5]:
    gamma_corrected = np.array(255*(img/255)**gamma,dtype = 'uint8')
    cv2.imshow("Gamma Correction" + str(gamma),gamma_corrected)
    cv2.imwrite("GammaCorrected" + str(gamma) + ".jpg",gamma_corrected)
