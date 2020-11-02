# loyalty-station-android-sdk

## Introduction 

Gamiphy Loyalty & Rewards, is a gamified loyalty program plugin/widget for eCommerce. You will be able to reward users with points for completing pre defined "challenges" within your store. In addition to that users can compete with each other in compeitions reflected on a leaderboard, receive badges and invite their freinds, among other gamified features.


## Requirements

- iOS 9.0+ / macOS 10.10+
- Xcode 9.0+
- Swift 4+

## Installation

Gamiphy Loyalty Station is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LoyaltyStation'
```

## Getting started

Gamiphy SDK needs to be initialized in Application class, you can do that by calling the init methid as shown below, and pass some required data / parameters that 
you can get after you signup for an account at Gamiphy. Kindly note the initilize method below. 

```swift
    LoyaltyStation
        //Set app id (required)
        .setApp(app: String?)
        //Set user data (optional)
        .setUser(
            user: User(
                //User id (required)
                id: String, 
                //User first name (required)
                firstName: String, 
                //User last name (required)
                lastName: String, 
                //User country (required)
                country: String?, 
                //User referral (optional) - Check referral section
                referral: UserReferral(
                    //User referrer id (required)
                    referrer: String
                ), 
                //User hmac hash result (required)
                hash: String
            )
        )
        //Gamiphy custom agent key (optional)
        .setAgent(agent: String)
        //Preferred language to show (optional)
        .setLanguage(language: String)
        //Open within sandbox (optional)
        .setSandbox(sandbox: Bool)
        //Start initialization
        .initialize()
```
To open the bot, use the following line.
```swift
    LoyaltyStation.open(on: self)
```


## Widget visitor flow 

Gamiphy Loyalty Station support the ability for the end users to navigate the different features available, without even being logged in. But whenever the users trying to perform actions they will be redirected to either login or signup to the application. You need to specify the Activity where the users can login / register in your application. OnAuthTrigger method called when click signUp/login in the widget. isSignUp true for signup redirection, isSignUp false for login redirection.

In login activity, after the user logged in, set user name and email and start gamiphy view
```swift
    LoyaltyStation.login(
         user: User(
             //User id (required)
             id: String, 
             //User first name (required)
             firstName: String, 
             //User last name (required)
             lastName: String, 
             //User country (required)
             country: String?, 
             //User referral (optional) - Check referral section
             referral: UserReferral(
                 //User referrer id (required)
                 referrer: String
             ), 
             //User hmac hash result (required)
             hash: String
         )
    )
```


## Referral program integration

Loyalty station supports users referrals through firebase dynamic links. Gamiphy system generates a dynamic link for every user. This link includes the referrer id of the original user.
To get the benefit of the referral system, you need to pass the dynamic link parameter to the Loyalty station sdk. The SDK will handle it from there.

### Parse dynamic link
Follow the firebase official doc to parse the dynamic link and read the required parameter. You can check [here](https://firebase.google.com/docs/dynamic-links/ios/receive).

### Pass referrer parameter 
You need to read the `ls-referrer` parameter from the dynamic link and pass it to the Loyalty station under user.referral.referrer