# Gamiphy SDK

[![Version](https://img.shields.io/cocoapods/v/gamiphy.svg?style=flat)](https://cocoapods.org/pods/Gamiphy)
[![License](https://img.shields.io/cocoapods/l/gamiphy.svg?style=flat)](https://cocoapods.org/pods/Gamiphy)

## Inroduction 

Gamibot, is the loyalty program that provide gamified user journey, with rewarding system, where users can get points by doing certine actions. and they 
can be rewarded for doing these actions. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+ / macOS 10.10+
- Xcode 9.0+
- Swift 4+

## Installation

gamiphy is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Gamibot'
```

## Getting started

Gamiphy SDK needs to be initialized, you can do that by calling the initialize method as shown below, and pass some required data/parameters that 
you can get after you signup for an account at Gamiphy. kindly note the initialize method below. 

```swift
var options = GamiphyBotOptions()
options.hMacKey = ""
options.clientID = ""
GamiphySDK.shared.initialize(botID: "", options: options)
```

## Showing the bot within your application

Gamibot can be triggered and shown in two methods. 

- If you are interested to use the widget that Gamiphy SDK provides, this widget will handle opening the bot within the web view. 

```swift

let button = GamiphyBotButton(frame: CGRect.zero)
self.view.addSubview(button)
```

- If you are interested in having your own widget/button that will be responsible to open the bot, or you want to open the bot after a certain action. you can do so by calling the following method: 

```swift

GamiphySDK.shared.showBot(on: viewController)
```

- If you want to hide the current active bot view you can use this code.

```swift

GamiphySDK.shared.hideBot()
```

## Bot visitor flow 

Gamibot supports the ability for the end-users to navigate the different features available, without even being logged in. but whenever the users trying to perform the tasks/actions so they can get the points, Gamibot will encourage them to either login or signup to the application. 

You need to specify the ViewControllers where the users can login/register in your application. you should implement the delegate by doing as the following: 

```swift
GamiphySDK.shared.delegate = self
```
Delegate Methods:

- Did auth user which called when there is success login for the user.

```swift

    func gamiphySDK(didAuthUser email: String)
```

- Failed to auth user when authenticating user failed and returns the error that caused it.

```swift

    func gamiphySDK(failedToAuthUser email: String, with error: Error)
```

- Did Trigger event with the event name, this method called when an event triggered by the bot and returned the action name.

```swift
    func gamiphySDK(didTriggerEvent name: String)
```

- User requires login, this method called when the bot requires login for the user or the login button inside bot clicked.

```swift

   func gamiphySDKUserNotLoggedIn()
```

- User requires Register, this method called when the bot requires to register for the user or the signup button inside bot clicked.

```swift

   func gamiphySDKUserNotRegistered()
```

## Registering the users

As Gamibot is a loyalty program that should be able to give points for the users, you can simply register your users for our SDK by calling this method. 

```swift
   var user = GamiphyUser(name: "", email: "")
   GamiphySDK.shared.authUser(user: user)
```

you need to call this method in both cases the login/signup if you do instant login of your users after they login/signup. 


## Creating the tasks: 


You need to send the custom event actions whenever it done using the method triggerTask shown below.
This method takes the event name label and mark it as done.

```swift
func triggerTask(name: String, arguments: [AnyHashable: String])
```

