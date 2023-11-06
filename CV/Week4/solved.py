import cv2
import numpy as np

image = cv2.imread('resources\\lenna.jpg')
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)

ret, thresh1 = cv2.threshold(gray,120,255,cv2.THRESH_BINARY)
ret, thresh2 = cv2.threshold(gray,120,255,cv2.THRESH_BINARY_INV)
ret, thresh3 = cv2.threshold(gray,120,255,cv2.THRESH_TRUNC)
ret, thresh4 = cv2.threshold(gray,120,255,cv2.THRESH_TOZERO)
ret, thresh5 = cv2.threshold(gray,120,255,cv2.THRESH_TOZERO_INV)

cv2.imshow("Original",gray)
cv2.imshow('Binary Threshold',thresh1)
cv2.imshow('Binary Threshold Inverted',thresh2)
cv2.imshow('Truncated Threshold',thresh3)
cv2.imshow('Set to 0',thresh4)
cv2.imshow('Set to 0 Inverted',thresh5)

cv2.waitKey(0)
cv2.destroyAllWindows()
