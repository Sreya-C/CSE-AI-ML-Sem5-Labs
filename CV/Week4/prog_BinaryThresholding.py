import cv2
import numpy as np

image = cv2.imread('resources\\lenna.jpg')
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
thresh = 255 // 2
cv2.imshow("Original",gray)

for i in range(len(gray)):
    for j in range(len(gray[0])):
        if gray[i][j] >= thresh:
            gray[i][j] = 255
        else:
            gray[i][j] = 0
cv2.imshow('Binary Threshold',gray)

cv2.waitKey(0)
cv2.destroyAllWindows()