## libconorthedev
This repository contains the code for an open source library that contains common functions / tools used between all of my iOS Tweaks

## Classes
### CTDColorUtils
```objective-c
/*
 * Gets the most average color from a UIImage
 * @param image - UIImage
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image;

/*
 * Gets the most average color from a UIImage with a custom alpha
 * @param image - UIImage
 * @param alpha - double
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image withAlpha:(double)alpha;

/*
 * Gets a readable text colour from the background colour
 * @param backgroundColor - UIColor
 * @return UIColor - the text color
 */
- (UIColor *)readableForegroundColorForBackgroundColor:
    (UIColor *)backgroundColor;
```

## For Developers
If you wish to use libconorthedev, here's the setup instructions:
- 1: Clone the GitHub Repository: ``git clone git@github.com:ConorTheDev/libconorthedev.git``
- 2: Change your current directory : ``cd libconorthedev``
- 3: Run ``make clean stage`` 
   - *This installs all neccessary files into ``$(THEOS)/include/ConorTheDev`` and ``$(THEOS)/lib/``*
- 4: Update your project's makefile:
    ```make
    project_LIBRARIES += (your libraries) conorthedev
    ```
- 5: Add it as a dependency to your control file:
    ```control
    Depends: me.conorthedev.libconorthedev
    ```