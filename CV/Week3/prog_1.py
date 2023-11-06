import cv2
import numpy as np

image = cv2.imread("resources\\train.jpg")
cv2.imshow("Original",image)
cv2.waitKey(0)


#Gaussian Blur - To smoothen and to remove noise
gaussian = cv2.GaussianBlur(image,(3,3),0)
cv2.imshow("Gaussian Blur",gaussian)
cv2.waitKey(0)

#Median Blur - To remove salt and pepper noise
median = cv2.medianBlur(image,3)
cv2.imshow("Median Blur",median)
cv2.waitKey(0)

#Average Blur
blur = cv2.blur(image,(3,3))
cv2.imshow("Average Blur",blur)
cv2.waitKey(0)