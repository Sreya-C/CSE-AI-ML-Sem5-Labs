import cv2
import numpy as np

'''
#Reading an image
# The function cv2.imread() is used to read an image.
img= cv2.imread('flower.jpg', 1)
img_color = cv2.imread('flower.jpg',cv2.IMREAD_COLOR)
img_grayscale = cv2.imread('flower.jpg',0)
img_unchanged = cv2.imread('flower.jpg',cv2.IMREAD_UNCHANGED)


# The function cv2.imshow() is used to display an image in a window.
cv2.imshow('graycsale image', img_grayscale)
cv2.imshow('Original image', img)
cv2.imshow("Unchanged",img_unchanged)
# waitKey() waits for a key press to close the window and 0 specifies indefinite loop
cv2.waitKey(0)

# cv2.destroyAllWindows() simply destroys all the windows we created.
cv2.destroyAllWindows()

# The function cv2.imwrite() is used to write an image.
cv2.imwrite('grayscale.jpg', img_grayscale)


#-------------------------------------------------------------------

#Reading a Video #


import numpy as np
import cv2
vid_capture = cv2.VideoCapture(0)
frame_width = int(vid_capture.get(3))
frame_height = int(vid_capture.get(4))
frame_size = (frame_width,frame_height)
output = cv2.VideoWriter('output_video.avi', cv2.VideoWriter_fourcc(*'XVID'), 20, frame_size)

if (vid_capture.isOpened() == False):
    print("Error opening the video file")
# Read fps and frame count
else:
    fps = vid_capture.get(5)
    print('Frames per second : ', fps, 'FPS')
    frame_count = vid_capture.get(7)
    print('Frame count : ', frame_count)

while (vid_capture.isOpened()):
    ret, frame = vid_capture.read()
    if ret == True:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        output.write(gray)
        cv2.imshow('Frame', gray)
        key = cv2.waitKey(20)

        if key == ord('q'):
            break
    else:
        break

vid_capture.release()
output.release()
cv2.destroyAllWindows()


#-------------------------------------------------------------------
'''
import numpy as np
import cv2
img= cv2.imread('flower.jpg', 1)
print(img.shape)
pix = img[100,100]
print(pix)

#Resizing
down_width = 500
down_height = 400
down_points = (down_width, down_height)
resized = cv2.resize(img,down_points,interpolation = cv2.INTER_LINEAR)
down_width = 300
down_height = 200
down_points = (down_width, down_height)
resized_down = cv2.resize(img, down_points, interpolation= cv2.INTER_LINEAR)
#cv2.imshow("Bigger",resized)
#cv2.imshow("Smaller",resized_down)


#Image Cropping
cropped = img[100:400,300:400]
#cv2.imshow("Cropped",cropped)


#Rotation of an Image
height, width = img.shape[:2]
center = (width/2, height/2)
rotate_matrix = cv2.getRotationMatrix2D(center=center,angle=45,scale=1)
rotated = cv2.warpAffine(src=img,M=rotate_matrix,dsize=(width,height))
#cv2.imshow('Rotated image', rotated)


#Splitting into BGR
b,g,r = cv2.split(img)
# cv2.imshow('Blue', b)
# cv2.imshow('Green', g)
# cv2.imshow('Red', r)

zeros = np.zeros(img.shape[:2], dtype="uint8")
red = cv2.merge([zeros,zeros, r])
blue = cv2.merge([b,zeros,zeros])
green = cv2.merge([zeros, g, zeros])

# cv2.imshow("Merged Blue", blue)
# cv2.imshow("Merged Red", red)
# cv2.imshow("Merged Green", green)

cv2.waitKey(0)
cv2.destroyAllWindows()

rectangle = cv2.rectangle(img,(384,284),(510,128),(0,255,0),5)
cv2.imshow("Rectangle", rectangle)


cv2.waitKey(0)
cv2.destroyAllWindows()
