import cv2
import numpy as np
import matplotlib.pyplot as plt

def Canny_edge_detector(img,thlow = None,thhigh = None):
    # 1- Gaussian Smoothing
    gimg = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gimg = cv2.GaussianBlur(gimg,(5,5),1.4)

    #2 - Compute Gradient
    gradient_x = cv2.Sobel(np.float32(gimg),cv2.CV_64F, 1, 0, 3)
    gradient_y = cv2.Sobel(np.float32(gimg),cv2.CV_64F, 0, 1, 3)

    #3- Compute Magnitude and Direction
    mag,dir = cv2.cartToPolar(gradient_x,gradient_y,angleInDegrees=True)

    # Setting minimum and maximum thresholds for Hysterisis Thresholding
    mag_max = np.max(mag)
    if not thlow: thlow = mag_max * 0.1
    if not thhigh: thhigh = mag_max  * 0.5

    height, width = gimg.shape

    #For every pixel:
    for i_x in range(width):
        for i_y in range(height):
            grad_ang = dir[i_y, i_x]
            grad_ang = abs(grad_ang - 180) if abs(grad_ang) > 180 else abs(grad_ang)

            # X-axis
            if grad_ang <= 22.5:
                neighb_1_x, neighb_1_y = i_x - 1, i_y
                neighb_2_x, neighb_2_y = i_x + 1, i_y

                # top right (diagonal-1)
            elif grad_ang > 22.5 and grad_ang <= (22.5 + 45):
                neighb_1_x, neighb_1_y = i_x - 1, i_y - 1
                neighb_2_x, neighb_2_y = i_x + 1, i_y + 1

                # Y-axis
            elif grad_ang > (22.5 + 45) and grad_ang <= (22.5 + 90):
                neighb_1_x, neighb_1_y = i_x, i_y - 1
                neighb_2_x, neighb_2_y = i_x, i_y + 1

                # top left (diagonal-2) direction
            elif grad_ang > (22.5 + 90) and grad_ang <= (22.5 + 135):
                neighb_1_x, neighb_1_y = i_x - 1, i_y + 1
                neighb_2_x, neighb_2_y = i_x + 1, i_y - 1

                # Now it restarts the cycle
            elif grad_ang > (22.5 + 135) and grad_ang <= (22.5 + 180):
                neighb_1_x, neighb_1_y = i_x - 1, i_y
                neighb_2_x, neighb_2_y = i_x + 1, i_y

                # Non-maximum suppression step
            if width > neighb_1_x >= 0 and height > neighb_1_y >= 0:
                if mag[i_y, i_x] < mag[neighb_1_y, neighb_1_x]:
                    mag[i_y, i_x] = 0
                    continue

            if width > neighb_2_x >= 0 and height > neighb_2_y >= 0:
                if mag[i_y, i_x] < mag[neighb_2_y, neighb_2_x]:
                    mag[i_y, i_x] = 0

    weak_ids = np.zeros_like(gimg)
    strong_ids = np.zeros_like(gimg)
    ids = np.zeros_like(gimg)

    # Hysterisis thresholding step
    for i_x in range(width):
        for i_y in range(height):

            grad_mag = mag[i_y, i_x]

            if grad_mag < thlow:
                mag[i_y, i_x] = 0
            elif thhigh > grad_mag >= thlow:
                ids[i_y, i_x] = 1
            else:
                ids[i_y, i_x] = 2

    return mag


frame = cv2.imread('resources\\lenna.jpg')

canny_img = Canny_edge_detector(frame)

# Displaying the input and output image
cv2.imshow("Canny",canny_img)

cv2.waitKey(0)
cv2.destroyAllWindows()