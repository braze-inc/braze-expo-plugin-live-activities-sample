<p align="center">
  <img width="480" src=".github/assets/logo-light.png#gh-light-mode-only" />
  <img width="480" src=".github/assets/logo-dark.png#gh-dark-mode-only" />
</p>

# Sample integration of Braze Live Activities in Expo

> ⚠️ Disclaimer: This repo to be used as reference to show a working integration of Braze Live Activities in an Expo app and will not be maintained with future updates. Braze will not be responsible for debugging customer integrations through the regular Support channels. ⚠️

## Overview

To integrate Braze Live Activities in an Expo application, you will need to add several parts of custom code to your host application. All of the additional code will live in your host app, and there are no changes in the Braze-owned plugin code.

There are 3 main parts of this integration: create a new Live Activities Xcode target (extension), create a local Expo module, and import the local Expo module into your host Expo application.

> Note that you will not be able to run this sample app on your own since it requires access to the Braze Apple Developer Account.

## 1. Create a Live Activities Xcode target

Since the iOS Live Activities objects are only available by Apple in the Swift language, we need to use Swift code to reference these classes. Similar to the [native Live Activities setup steps](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b4-live-activities), we need to add a new widget extension into the Xcode project that includes relevant content for the Live Activity itself.

In this example, we leverage [this unofficial, open-source library written by an Expo employee](https://github.com/EvanBacon/expo-apple-targets) to add a new target to the Xcode project. We followed the instructions in the README to add the package to the `app.json` and `package.json`, and the relevant code can be found in [this folder](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/tree/main/example/targets/live-activities). Note that the files in this folder are owned by the customer, meaning all the customization (e.g. UI, naming) can be updated as desired.

> ⚠️ As a disclaimer, we don't own any of the code related to this third-party library, and there is always a risk of bugs when relying on an experimental plugin. However, currently no official Expo packages exist to support such a feature. ⚠️

### Known issues

When using this third-party package, we discovered the same root problem as [this public Github issue](https://github.com/EvanBacon/expo-apple-targets/issues/19), where only the last target of a multi-target project would be signed when using Expo Application Services (EAS). Fortunately, the same person who filed the issue also submitted a fix [here](https://github.com/EvanBacon/expo-apple-targets/pull/20).

However, as noted above, we warn against using unofficial third-party packages like this one when integrating Live Activities in Expo. To add a target extension without a third-party package, you can write your own `ConfigPlugin` script to edit the Xcode project. To see an example of how to do this, reference [this part of our script](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/plugin/src/withBrazeiOS.ts#L134-L229) that modifies the Xcode project to add targets for Rich Push or Push Stories.

## 2. Create a local Expo module

The next step is to create a custom Expo module that will be ultimately imported into your host Expo application. Reference [this folder](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/tree/main/example/modules/live-activity-example) in our sample app to see sample code.

### Using a mod to edit the Live Activity target

The mod [in this file](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/modules/live-activity-example/src/withLiveActivities.ts) modifies the project's `Podfile` to make the new Live Activities Xcode target import `BrazeKit`, which exposes the relevant Braze Live Activities APIs. For more information about Expo mods, see [their official documentation](https://docs.expo.dev/config-plugins/plugins-and-mods/).

### Calling the Braze Live Activities APIs

We are able to call Braze's Live Activities APIs via this module because of the different parts:
- This module contains a [`podspec` which imports `BrazeKit` as a dependency](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/modules/live-activity-example/ios/LiveActivityExample.podspec#L15).
- The [Typescript interface](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/modules/live-activity-example/src/index.ts) contains the APIs that the host Expo app calls.
- The Swift code [in this file](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/modules/live-activity-example/ios/LiveActivityExampleModule.swift) calls the relevant `BrazeKit` methods and also exposes the Swift API, which is called from the Typescript interface above.

> **Important**: Note that the `LiveActivityExampleAttributes` is copied in both the module [here](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/modules/live-activity-example/ios/LiveActivityExampleModule.swift#L12-L25) as well as [the target's Swift code](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/targets/live-activities/LiveActivityExample.swift#L13-L26). This is needed to ensure that both the module and the Xcode target code are referencing a Live Activity object with the same exact structure and fields.

### Building the module

To prepare this new module for usage in your host application, open [this directory](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/tree/main/example/modules/live-activity-example) and run `yarn install` and then `yarn build`.

## 3. Putting it all together

After running the typical build / prebuild steps for your Expo application, you should be able to import your module directly into your Typescript code in your host Expo application, [like shown here](https://github.com/braze-inc/braze-expo-plugin-live-activities-sample/blob/main/example/components/Braze.tsx#L3). Then, you will be able to use the full Braze Live Activities APIs directly in Typescript.

Now that you’ve set up the scaffolding for Live Activities in your Expo project, refer to the [native integration documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/swift/live_activities/live_activities) for further details on when and how to call the Braze APIs. If you are using EAS, [follow the official Expo documentation](https://docs.expo.dev/build/introduction/) for setup.

-------

# Braze Expo Plugin

Effective marketing automation is an essential part of successfully scaling and managing your business. Braze empowers you to build better customer relationships through a seamless, multi-channel approach that addresses all aspects of the user life cycle. Braze helps you engage your users on an ongoing basis.

- [Braze User Guide](https://www.braze.com/docs/user_guide/introduction)
- [Initial Setup](https://www.braze.com/docs/developer_guide/platform_integration_guides/react_native/react_sdk_setup/)

## About

This Expo Config plugin auto configures the [`Braze React Native SDK`](https://www.npmjs.com/package/@braze/react-native-sdk) when the native code is generated (`expo prebuild`). See the [documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/react_native/react_sdk_setup/) for details on setup and configuration options.

## Version Support

| Braze Expo Plugin | Braze React Native SDK |
| ----------------- | ---------------------- |
| >=2.0.0           | >= 8.3.0               |
| >=1.1.0           | >= 2.1.0               |
| 1.0.0 - 1.0.1     | >= 2.0.2               |
| <= 0.6.0          | 1.38.0 - 1.41.0        |
