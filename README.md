# DryDock
An internal installer app for iOS.

### What is drydock?
DryDock is an iOS application that we built at Venmo to manage and install all of our internal builds, allow employees to download new experimental apps at any time and to easily share builds designed for a broader audience with their friends. 

DryDock also allows our customer support team to install any version of the App that we've ever released to the store.

<img src="http://f.cl.ly/items/091P1Q0W250H2b3e3T1S/DryDockScreen.png" width="320" />

### Getting set up with DryDock

DryDock is built on the `Parse` backend to make it really simple (and free) for anybody to host their own version of DryDock.

#### 1. Create a Parse.com app
Go to http://parse.com. Sign up if you haven't already and then create a new iOS application. Do not download their starter project. Take a note of your `Application ID` & `Client Key`.

#### 2. Build DryDock iOS
- Check out this repo
- Run `pod install`
- Open `VenmoDryDock.xcworkspace`
- Set your Parse `applicationId` and `clientKey` in `VDDAppDelegate.m`
- (Optional) Set up `VENUpdateTracker` or delete the init code in the app delegate
- Run it on the Simulator or a device

#### 3. Go setup your data
When you ran DryDock for the first time, it noticed that you don't have any models set up on Parse and will create a sample app in the Parse databrowser. Go to your Apps' data browser and configure the available apps. You need to set at least:
```
name        :: The title of the app
description :: A short description (< 10 words)
type        :: 1 is 'internal', 2 is an 'AppStore release'
install_url :: The itms-services:// link to install the app. This can be a hockey-app / TestFlight download page if you don't want direct installation
share_url   :: The url for a download page for the app
```

<img src="https://photos-3.dropbox.com/t/0/AABbyhZ5pRQE1s94VvgVlcxBvGZakNCqKuHOaKbD8tIWPg/12/6397232/png/1024x768/3/1396818000/0/2/Screenshot%202014-04-06%2015.56.10.png/ywbbtshlT9lLd4uwbB5UTYj6c8QZYpaVHJ3ak8NyXag" width="100%" />

#### 4. Open DryDock on your iPhone
You should see the apps that you configured.

#### 5. Share & maintain
Now you can share this with your team! We're working on polishing up some tooling that we've built to update DryDock builds from your CI environment or build scripts. Hopefully we'll share this soon.

### License
DryDock is released under the MIT License

### Contributing

We'd love to see your ideas for improving DryDock! The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new Github issue](https://github.com/venmo/VENAppSwitchSDK/issues/new) if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style!

### Dry Dock on other platforms

We'd love to create DryDock for Android too -- and any other platforms! If you're interested in working on this then raise an Issue with a link to the repo so that we can make sure multiple people aren't working on the same port!
