# BackgroundRemoval

<img src="Screenshots/results.jpg" alt="Removal results" align="center" />

![License](https://img.shields.io/cocoapods/l/Gallery.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/Gallery.svg?style=flat)
![Swift](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)

## Description

<img src="Screenshots/logo.jpg" alt="Removal Icon" align="right" width="250" height="250" />

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
outputImage.image = BackgroundRemoval.init().removeBackground(image: image!)
```

The output will always be a `UIImage` in all cases.

### Mask Image

In case you wanted only The mask for your input image (black & white), then you case pass `maskOnly` arg to the library

```swift
let image = UIImage(named: "child")
segmentedImage.image = BackgroundRemoval.init().removeBackground(image: image!, maskOnly: true)
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

Ezaldeen sahb, let us connect https://www.linkedin.com/in/ezaldeen-sahb-17918b137/


## Contributing

We would love you to contribute to **Background Removal**, there is still a huge room for improvment.
