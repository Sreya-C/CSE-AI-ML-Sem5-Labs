import cv2
import numpy as np
import matplotlib.pyplot as plt

img = cv2.imread('resources\\lenna.jpg')
gray_img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)


gradient_x = cv2.Sobel(gray_img,cv2.CV_64F,dx=1,dy=0,ksize = 7)
gradient_y = cv2.Sobel(gray_img,cv2.CV_64F,dx=0,dy=1,ksize = 7)

gradient_mag = np.sqrt(gradient_y**2 + gradient_x**2)
gradient_angle = np.arctan2(gradient_y,gradient_x)

plt.subplot(2,2,1),plt.imshow(gray_img)
plt.title("Original"),plt.xticks([]),plt.yticks([])
plt.subplot(2,2,2),plt.imshow(gradient_mag)
plt.title("Magnitude"),plt.xticks([]),plt.yticks([])
plt.subplot(2,2,3),plt.imshow(gradient_angle)
plt.title("Direction"),plt.xticks([]),plt.yticks([])
plt.show()