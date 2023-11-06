import numpy as np
import cv2

query_img = cv2.imread('resources\\pan1.jpg')
train_img = cv2.imread('resources\\pan2.jpg')

query_img = cv2.resize(query_img, dsize=(200,200))
train_img = cv2.resize(train_img, dsize=(200,200))

query_img_bw = cv2.cvtColor(query_img, cv2.COLOR_BGR2GRAY)
train_img_bw = cv2.cvtColor(train_img, cv2.COLOR_BGR2GRAY)

orb = cv2.ORB_create()
queryKeypoints, queryDescriptors = orb.detectAndCompute(query_img_bw, None)
trainKeypoints, trainDescriptors = orb.detectAndCompute(train_img_bw, None)

matcher = cv2.BFMatcher()
matches = matcher.match(queryDescriptors, trainDescriptors)

final_img = cv2.drawMatches(query_img, queryKeypoints,train_img, trainKeypoints, matches[:20], None)
final_img = cv2.resize(final_img, (1000, 650))

cv2.imshow("Matches", final_img)
cv2.waitKey(0)
cv2.destroyAllWindows()
