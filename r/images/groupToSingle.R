# Group to Single Images
#https://www.datanovia.com/en/blog/easy-image-processing-in-r-using-the-magick-package/
#https://www.digitalocean.com/community/tutorials/how-to-detect-and-extract-faces-from-an-image-with-opencv-and-python
pacman::p_load(tidyverse, magick)

str(magick::magick_config())

dir1 ='/Users/du/Downloads/groupPhotos'
dir(dir1)
frink <- image_read(paste0(dir1 , '/image5.jpeg'))
print(frink)

# Shows some meta data about the image
image_info(frink)

image_border(image_background(frink, "hotpink"), "#000080", "20x10")

image_trim(frink)

image_crop(frink, "100x150+50")

# Width: 300px
image_scale(frink, "300") 
# Height: 300px
image_scale(frink, "x300") 


image_crop(frink, "100x150+50")
#Crop an image

#Resize the image:
# Width: 300px
image_scale(frink, "300") 
# Height: 300px
image_scale(frink, "x300") 
#Rotate or mirror the image

image_rotate(frink, 45)
image_flip(frink)
image_flop(frink)

# Change the brightness, the saturation and the Hue
image_modulate(frink, brightness = 80, saturation = 120, hue = 90)

# Paint the shirt in blue
image_fill(frink, "blue", point = "+100+200", fuzz = 20)

# Add some text
image_annotate(
  frink, text = "73rdNDA C Sqn", size = 70, color = "green",
  gravity = "southwest"
)

# Customize text
image_annotate(
  frink, text = "73rdNDA C Sqn", size = 30, 
  color = "red", boxcolor = "pink",
  degrees = 0, location = "+300+100",
  font = "Times"
)
