import cv2
import matplotlib.pyplot as plt
import numpy as np
img = cv2.imread("resources\\dark.jpg",1)
cv2.imshow("Original",img)

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