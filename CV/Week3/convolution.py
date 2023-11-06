import cv2
import numpy as np

def convolve(image, kernel):
    (image_height, image_width) = image.shape
    (kernel_height, kernel_width) = kernel.shape

    # Compute the padding needed for the output image
    padding_height = kernel_height // 2
    padding_width = kernel_width // 2

    # Create an empty array to store the convolved image
    convolved_image = np.zeros_like(image)

    # Pad the image
    padded_image = np.pad(image, ((padding_height, padding_height), (padding_width, padding_width)), mode='constant')

    # Perform convolution
    for i in range(image_height):
        for j in range(image_width):
            # Extract the region of interest (ROI)
            roi = padded_image[i:i+kernel_height, j:j+kernel_width]

            # Perform element-wise multiplication between the ROI and the kernel
            convolved_pixel = np.sum(np.multiply(roi, kernel))

            # Assign the convolved pixel value to the output image
            convolved_image[i, j] = convolved_pixel

    return convolved_image

# Load the image
image = cv2.imread('resources\\lenna.jpg', 0)

# Define the custom kernel
kernel=np.ones((3,3),dtype=np.float32)/25.0


# Perform convolution on the image
convolved_image = convolve(image, kernel)

# Display the original and convolved images
cv2.imshow('Original Image', image)
cv2.imshow('Convolved Image', convolved_image)
cv2.waitKey(0)
cv2.destroyAllWindows()