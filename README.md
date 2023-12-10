# BackgroundRemoval

<img src="https://github.com/Ezaldeen99/BackgroundRemoval/blob/main/ScreenShots/results.jpg" alt="Removal results" align="center" />

![License](https://img.shields.io/static/v1?style=for-the-badge&message=Apache&color=D22128&logo=Apache&logoColor=FFFFFF&label=)
![Platform](https://img.shields.io/static/v1?style=for-the-badge&message=iOS&color=000000&logo=iOS&logoColor=FFFFFF&label=)
![Swift](https://img.shields.io/static/v1?style=for-the-badge&message=Swift&color=F05138&logo=Swift&logoColor=FFFFFF&label=)

## Description

<img src="https://github.com/Ezaldeen99/BackgroundRemoval/blob/main/ScreenShots/logo.jpg" alt="Removal Icon" align="right" width="250" height="250" />

We depends heavily on Images these days, and sometimes developers need to make processing on these files and one of these things that give us headache is backgorund removal, I really hate that there are so few open source background removal models and libraries so I decided to make this library open source so people can use it, If this suits your need, give it a try 😉

`Background removal` can give you two different outouts

- Mask Image: The mask for your input image (black & white) so you can do any processing that you needs
- Output image: ( default case) your output image without its background 

And, it has zero dependencies 😎

## Usage

### Output image

To start the background removal on your image you just need to pass a `UIImage` component to the library and get your output image, only that 

```swift
let image = UIImage(named: "child")
let backgroundRemoval = BackgroundRemoval()
do {
    outputImage.image = try backgroundRemoval.removeBackground(image: image!)
} catch {
    print(error)
}
```

The output will always be a `UIImage` in all cases.

### Mask Image

In case you wanted only The mask for your input image (black & white), then you case pass `maskOnly` arg to the library

```swift
let image = UIImage(named: "child")
let backgroundRemoval = BackgroundRemoval()
do {
    segmentedImage.image = try backgroundRemoval.removeBackground(image: image!, maskOnly: true)
} catch {
    print(error)
}
```


### Improve results

you may see some shadows on the edges after you remove the background, you can add some filters on your mask before you mask the input image to get the output result, here is an example of a good tested workaround that gave me a better resutls

```swift
let image = UIImage(named: "child")
let scaledOut = BackgroundRemoval.init().removeBackground(image: image!, maskOnly: true)


/// post processing to get rid of image blur
let imageSource = BBMetalStaticImageSource(image: scaledOut)

// Set up some filters for mask post processing
let contrastFilter = BBMetalContrastFilter(contrast: 3)
let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)

// Set up filter chain
// Make last filter run synchronously
imageSource.add(consumer: contrastFilter)
 //   .add(consumer: lookupFilter)
    .add(consumer: sharpenFilter)
    .runSynchronously = true

// Start processing
imageSource.transmitTexture()

// Get filtered mask
let filteredImage = sharpenFilter.outputTexture?.bb_image

```


### iOS version

The model supports macOS = 11, iOS = 14. however the library currently supports only iOS systems.



## Installation

**Background Removal** is available through [Package Manager](https://www.swift.org/package-manager/). To install
it, simply copy the url file and click add package in your xcode and paste it:

```
https://github.com/Ezaldeen99/BackgroundRemoval.git
```

## Author

Ezaldeen sahb, let us connect https://www.linkedin.com/in/ezzulddin-abdulzahra-17918b137


## Contributing

We would love you to contribute to **Background Removal**, there is still a huge room for improvment.


## Credits
The library wouldn't be done without the effort of open source community specially.
- [U-2-Net](https://github.com/xuebinqin/U-2-Net)
- [SmartyToe](https://github.com/SmartyToe/Image-segmentation)



## License
Project is published under the Apache 2.0 license. Feel free to clone and modify repo as you want, but don't forget to add reference to authors :)

