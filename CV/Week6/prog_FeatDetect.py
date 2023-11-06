import cv2
import matplotlib.pyplot as plt
import numpy as np

#FAST Feature Detection
# Reading the image and converting into B/W
image = cv2.imread('resources\\lenna.jpg')
image = cv2.resize(image,(720,648))
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Applying the function
fast = cv2.FastFeatureDetector_create()
fast.setNonmaxSuppression(False)
kp = fast.detect(gray_image, None)
kp_image = cv2.drawKeypoints(image, kp, None, color=(0, 255, 0))

cv2.imshow('FAST', kp_image)
cv2.waitKey()
cv2.destroyAllWindows()

## ORB Feature Detection

train_img = cv2.imread('resources\\lenna.jpg')
train_img = cv2.resize(image,(720,648))
train_img_bw = cv2.cvtColor(train_img, cv2.COLOR_BGR2GRAY)
orb = cv2.ORB_create()

trainKeypoints, trainDescriptors = orb.detectAndCompute(train_img_bw, None)
kp_image = cv2.drawKeypoints(train_img, trainKeypoints, None, color=(0, 255, 0))
cv2.imshow("ORB",kp_image)

cv2.waitKey(0)
cv2.destroyAllWindows()

##SIFT Feature Detection

image = cv2.imread('resources\\lenna.jpg')
image = cv2.resize(image,(720,648))
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
sift = cv2.SIFT_create()

kp1, des1 = sift.detectAndCompute(gray_image, None)
kp_image = cv2.drawKeypoints(image, kp1, None, color=(0, 255, 0))
cv2.imshow("SIFT",kp_image)

cv2.waitKey()
cv2.destroyAllWindows()

## BRIEF Feature Detection

import numpy as np

image = cv2.imread('resources\\lenna.jpg')
image = cv2.resize(image,(720,648))
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
brief = cv2.xfeatures2d.BriefDescriptorExtractor_create()
train_keypoints = fast.detect(gray_image, None)
train_keypoints, train_descriptor = brief.compute(gray_image,train_keypoints)
keypoints_without_size = np.copy(image)
keypoints_with_size = np.copy(image)
wosize = cv2.drawKeypoints(image, train_keypoints, keypoints_without_size, color = (0, 255, 0))
wsize = cv2.drawKeypoints(image, train_keypoints, keypoints_with_size, flags = cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
cv2.imshow("BRIEF without size",wosize)
cv2.imshow("BRIEF With size",wsize)

cv2.waitKey()
cv2.destroyAllWindows()
