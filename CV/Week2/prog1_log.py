import cv2
import numpy as np
img = cv2.imread("resources\\dark.jpg",1)

cv2.imshow("Original",img)
#Log Transform
c = 255/(np.log(1+np.max(img)))
log_transformed = c * np.log(1 + img) 
log_transformed = np.array(log_transformed,dtype = 'uint8')
cv2.imshow("Log Transform",log_transformed)
cv2.imwrite('resources\\Log_Transformed.jpg',log_transformed)
