#Harris corner Detection from scratch
import cv2
import numpy as np
import matplotlib.pyplot as plt

SOBEL_X = np.array((
    [-1, 0, 1],
    [-2, 0, 2],
    [-1, 0, 1]), dtype="int32")

# Sobel y-axis kernel
SOBEL_Y = np.array((
    [-1, -2, -1],
    [0, 0, 0],
    [1, 2, 1]), dtype="int32")

# Gaussian kernel
GAUSS = np.array((
    [1/16, 2/16, 1/16],
    [2/16, 4/16, 2/16],
    [1/16, 2/16, 1/16]), dtype="float64")

def convolve(img, kernel):
    if kernel.shape[0] % 2 != 1 or kernel.shape[1] % 2 != 1:
        raise ValueError("Only odd dimensions on filter supported")

    img_height = img.shape[0]
    img_width = img.shape[1]
    pad_height = kernel.shape[0] // 2
    pad_width = kernel.shape[1] // 2
    pad = ((pad_height, pad_height), (pad_height, pad_width))
    g = np.empty(img.shape, dtype=np.float64)
    img = np.pad(img, pad, mode='constant', constant_values=0)
    for i in np.arange(pad_height, img_height + pad_height):
        for j in np.arange(pad_width, img_width + pad_width):
            roi = img[i - pad_height:i + pad_height +
                                     1, j - pad_width:j + pad_width + 1]
            g[i - pad_height, j - pad_width] = (roi * kernel).sum()
    if (g.dtype == np.float64):
        kernel = kernel / 255.0
        kernel = (kernel * 255).astype(np.uint8)
    else:
        g = g + abs(np.amin(g))
        g = g / np.amax(g)
        g = (g * 255.0)
    return g

def harris(img, threshold=0.6):
    img_cpy = img.copy() # copying image
    img1_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) # grayscaling
    dx = convolve(img1_gray, SOBEL_X) # convolving with sobel filter on X-axis
    dy = convolve(img1_gray, SOBEL_Y) # convolving with sobel filter on Y-axis
    dx2 = np.square(dx) #Square of Derivative
    dy2 = np.square(dy) #Square of Derivative
    dxdy = dx*dy  #cross filtering
    # gauss filter for all directions (x,y,cross axis)
    g_dx2 = convolve(dx2, GAUSS)
    g_dy2 = convolve(dy2, GAUSS)
    g_dxdy = convolve(dxdy, GAUSS)
    # Harris Function
    harris = g_dx2*g_dy2 - np.square(g_dxdy) - 0.12*np.square(g_dx2 + g_dy2) # r(harris) = det - k*(trace**2)
    # Normalizing
    cv2.normalize(harris, harris, 0, 1, cv2.NORM_MINMAX)

    # find all points above threshold (nonmax supression line)
    loc = np.where(harris >= threshold)
    # drawing filtered points
    for pt in zip(*loc[::-1]):
        cv2.circle(img_cpy, pt, 3, (0, 0, 255), -1)

    return img_cpy,g_dx2,g_dy2,dx,dy,loc

img = cv2.imread("resources\\lines.jpg")
cv2.imshow("Original",img)
corners,g_dx2,g_dy2,dx,dy,loc = harris(img,0.75)
cv2.imshow("Corners",corners)

cv2.waitKey(0)
cv2.destroyAllWindows()