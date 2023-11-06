import cv2
import numpy as np
import matplotlib.pyplot as plt

import cv2

plt.figure(figsize=(8, 6))

img = cv2.imread('resources\\lines.jpg')

plt.subplot(1, 2, 1)
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
plt.xticks([])
plt.yticks([])
plt.title('Original Image')

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray, 100, 200, apertureSize=3)
lines = cv2.HoughLinesP(edges, 1, np.pi / 180, 127, minLineLength=100, maxLineGap=10)

if lines is not None:
    for line in lines:
        x1, y1, x2, y2 = line[0]
        cv2.line(img, (x1, y1), (x2, y2), (255, 0, 0), 2)

plt.subplot(1, 2, 2)
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
plt.xticks([])
plt.yticks([])
plt.title('Lines Detected using Hough Transform')

plt.tight_layout()
plt.savefig('line_hough.png')
plt.show()