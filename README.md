<img style="width:128px;float:right;padding:0px 20px;" src=droplet_icon/droplet.iconset/icon_1024x1024.png></img>

# Grayscale to RGB

Have you ever imported a black and white image into Capture One and found you cannot edit it? This is likely because your scanning software saved the image file in a grayscale color space. Capture One cannot edit grayscale images.

Grayscale to RGB makes it easy to batch convert the color profile of grayscale images to the AdobeRGB color space. This allows Capture One to edit them. The original image files are not touched. The tool writes a new image file with "RGB" appended to the source filename. For example, an file called "image.jpg" will have an output file of "imageRGB.jpg". Only the color profile is changed. The bits per channel and type are retained.

# Installation

Installation is really simple.

1. Double-click the "Grayscale to RGB" AppleScript to open it in Script Editor.
1. Click the right-arrow in top bar of the Script Editor to run it.
1. Choose the folder where you want the droplet created.

Once you have the style droplet created you are ready to use "Grayscale to RGB".

# How To Use

The droplet is easy to use and works like any other macOS application. You can drag-n-drop files onto it or you can double-click it and choose files.

- select files in Finder, drag-n-drop them onto the droplet, and it converts the dropped files
- double-click the created app, choose the files to convert, and it converts the selected files

It is that easy!

# How It Works

This section is for those who like to know how things work.

Grayscape to RGB uses the macOS `sips` tool to convert the color profile of selected images to AdobeRGB.

The Terminal window command looks like this:

```
sips -M /System/Library/ColorSync/Profiles/AdobeRGB1998.icc relative myFile.jpg -o myFileRGB.jpg
```