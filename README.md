# Grayscale to RGB

<img style="width:256px;float:right;padding:0px 20px;" src=droplet_icon/droplet.iconset/icon_1024x1024.png></img>

Have you ever imported a black and white image into Capture One and found you cannot edit it? This is likely because your scanning software saved the image file in a grayscale color space. Capture One cannot edit grayscale images.

Grayscale to RGB makes it easy for macOS users to batch convert the color profile of grayscale images to the AdobeRGB color space. This allows Capture One to edit them. The original image files are not touched. The tool writes a new image file with "RGB" appended to the source filename. For example, an file called "image.jpg" will have an output file of "imageRGB.jpg". Only the color profile is changed. The bits per channel and type are retained.

# Requirements

This tool only runs on macOS.

# Installation

Installation is really simple. It self-installs in the directory you choose. Just run the AppleScript script in Script Editor.

1. Download the project using the Download button at the top of this page.
1. Double-click "Grayscale to RGB.applescript" to open it in Script Editor.
1. Click the right-arrow in the top toolbar of the Script Editor to run it.
1. Choose the folder where you want the droplet created.

Once you install the style droplet you are ready to use "Grayscale to RGB".

# How To Use

The droplet is easy to use and works like any other macOS application. You can drag-n-drop files onto it or you can double-click it and choose files.

- select files in Finder, drag-n-drop them onto the droplet, and it converts the dropped files
- double-click the created app, choose the files to convert, and it converts the selected files

It is that easy!

# How It Works

This section is for those who like to know how things work.

Under the hood "Grayscale to RGB" uses the macOS `sips` tool to convert the color profile of selected images to AdobeRGB.

The Terminal window command looks like this:

```bash
$ sips -M /System/Library/ColorSync/Profiles/AdobeRGB1998.icc relative myFile.jpg -o myFileRGB.jpg
```

- `-M <target profile> <method>` specifies the target profile and method for conversion
- `-o output_file` specifies the target output file

If you want to read more about what `sips` can do you can type `man sips` at a Terminal window command prompt.