# libappearancecell

libappearancecell is a library for jailbroken iOS devices that allows developers to use an iOS 13-style appearance selector in their Preferences. 

<img src="https://cdn.discordapp.com/attachments/643863144091090964/679285839246655488/image0.png" alt="example usage" width="350"/>

## Usage
The setup of libappearancecell is very simple, just follow these () simple steps and you should be good to go!
- 1: Clone or [download](https://github.com/ConorTheDev/libappearancecell/archive/master.zip) this repository
- 2: ``cd libapperancecell && make do``
    - This will setup libappearancecell inside theos and will install it to your iDevice
- 3: Add ``$(BUNDLE_NAME)_LIBRARIES = appearancecell`` to your Preferences Makefile
- 4: ??
- 5: Profit!

## Documentation
### AppearanceSelectionTableCell
This is the main class for libappearancecell, it handles everything.
+ Example of usage in a Preferences Specifier:
```xml
<dict>
    <key>cell</key>
    <string>PSDefaultCell</string>
    <key>cellClass</key>
    <string>AppearanceSelectionTableCell</string>
    <key>firstOptionName</key>
    <string>option 1</string>
    <key>secondOptionName</key>
    <string>option 2</string>
    <key>firstOptionImage</key>
    <string>/Library/PreferenceBundles/libappearancecell_demo.bundle/demo.png</string>
    <key>secondOptionImage</key>
    <string>/Library/PreferenceBundles/libappearancecell_demo.bundle/demo.png</string>
    <key>defaults</key>
    <string>me.conorthedev.libappearancecell.demo</string>
    <key>PostNotification</key>
    <string>me.conorthedev.libappearancecell.demo/reload</string>
    <key>key</key>
    <string>appearance</string>
    <key>height</key>
    <integer>160</integer>
</dict>
```
#### All keys listed above are *required*, failing to supply these will make it not work.

## Preference Bundle Example
If you're a bit stuck on the integration, there's an example of a working Preference Bundle [here](https://github.com/ConorTheDev/libappearancecell/tree/master/PreferencesExample).