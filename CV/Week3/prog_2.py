import cv2
import numpy as np

def unsharp(image, sigma, strength):
    image_mf = cv2.medianBlur(image, sigma)
    lap = cv2.Laplacian(image_mf, cv2.CV_64F)
    sharp = image - strength * lap
    sharp[sharp>255] = 255
    sharp[sharp<0] = 0
    return sharp

original_image = cv2.imread('resources\\leuven.jpg')
cv2.imshow("Original",original_image)
sharp1 = np.zeros_like(original_image)
for i in range(3):
    sharp1[:,:,i] = unsharp(original_image[:,:,i], 5, 0.8)

gray = cv2.imread('resources\\leuven.jpg',0)
sharp2 = unsharp(gray,5,0.8)

cv2.imshow("Original",original_image)
cv2.imshow("Gray Image",gray)
cv2.waitKey(0)

cv2.imshow("Sharp",sharp1)
cv2.imshow("Sharpgray",sharp2)
cv2.waitKey(0)
