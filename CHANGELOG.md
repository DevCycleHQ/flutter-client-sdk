# Change Log
## [1.8.3] - 2024-04-26
## Other Changes

- chore: release v2 - move all into one file again by @JamieSinn in #148



## Uncategorized



## [1.8.2] - 2024-04-26
## Other Changes

- chore: Enable flutter's native auto publishing based on github tags. by @JamieSinn in #147



## Uncategorized



## [1.8.1] - 2024-04-26
## Bug Fixes

- fix: use raw value instead of returning internal enum class by @jsalaber in #146



## Uncategorized

- Change dependabot to weekly by @JamieSinn in #144


## [1.8.1] - 2024-04-26
## Bug Fixes

- fix: use raw value instead of returning internal enum class by @jsalaber in #146



## Uncategorized

- Change dependabot to weekly by @JamieSinn in #144


## [1.8.0] - 2024-04-24
## Features

- feat: add apiProxyUrl and eventsApiProxyUrl options to the DevCycle Options Builder by @kaushalkapasi in #139

## Bug Fixes

- fix: update iOS options builder to use the right proxyURL builder options by @kaushalkapasi in #140
- fix: update Android minSdkVeresion to 23 (Android 6.0 - Marshmallow) by @kaushalkapasi in #142

## Other Changes

- chore: Update android example app by @kaushalkapasi in #141
- chore: Fix release action by @kaushalkapasi in #143



## Uncategorized



## [1.7.5] - 2024-04-19
## Features

- feat: add apiProxyUrl and eventsApiProxyUrl options to the DevCycle Options Builder by @kaushalkapasi in #139



## Uncategorized



## [1.7.4] - 2024-04-18


## Uncategorized

- chore: Update DevCycle Deps by @kaushalkapasi in #137
- chore: Bump com.android.tools.build:gradle from 8.3.1 to 8.3.2 in /android by @dependabot[bot] in #138


## [1.7.3] - 2023-12-19


## Uncategorized

- Bump com.devcycle:android-client-sdk from 2.0.2 to 2.0.5 in /android by @dependabot[bot] in #129


## [1.7.2] - 2023-10-24


## Uncategorized

- chore: dependabot by @JamieSinn in #116
- chore(deps): actions/checkout from 2 to 4 by @dependabot[bot] in #120
- chore(deps): subosito/flutter-action from 1 to 2 by @dependabot[bot] in #118
- chore(deps): com.devcycle:android-client-sdk from 2.0.0 to 2.0.2 in /android by @dependabot[bot] in #119
- chore(deps): com.android.tools.build:gradle from 7.1.2 to 8.1.2 in /android by @dependabot[bot] in #117
- chore(deps): org.jetbrains.kotlin:kotlin-gradle-plugin from 1.6.10 to 1.9.10 in /android by @dependabot[bot] in #121


## [1.7.1] - 2023-08-09
## Bug Fixes

- fix: release action name change by @JamieSinn in #107
- fix: rename model files from dvc to devcycle by @jonathannorris in #110
- fix: Update versions for all sub-projects and add the changelog script by @JamieSinn in #111

## Build System / CI

- ci: revised how the changelog updates in the github action by @chris-hoefgen in #113
- ci: fixed incorrect changelog filename in release action by @chris-hoefgen in #114
- ci: another release action fix by @chris-hoefgen in #115



## Uncategorized

- chore: update to use the tagged version of the release action instead of main by @chris-hoefgen in #112



## [1.7.0] - 2023-07-27

- update Android to 2.0.0
- update iOS to 1.14.0
- External interfaces changed to use `DevCycle` over `DVC`. For example: `DVCClient` -> `DevCycleClient`, `DVCUser` -> `DevCycleUser`. 
Old interfaces are marked as deprecated.

## [1.6.10] - 2023-06-19

- add logging disabling methods `disableCustomEventLogging()` and `disableAutomaticEventLogging()`

## [1.5.1] - 2023-05-26

- bump Android version to 1.6.1

## [1.5.0] - 2023-05-25

- bump Android version to 1.6.0

## [1.4.0] - 2023-05-16

- Add `variableValue()` method to `DVCClient` to get the value of a variable for a user.
- Update `variable()` method to return non-optional value, will use default value if variable is not found.

## [1.3.3] - 2023-05-09

- Fix error handling, and update callbacks to pass errors as strings

## [1.3.2] - 2023-05-03

- bump Android version to 1.4.4

## [1.3.1] - 2023-04-11

- add builder method for disabling realtime updates using `.disableRealtimeUpdates()`

## [1.3.0] - 2023-03-24

- update ios and android version to latest release
- update support for flutter versions

## [1.2.0] - 2023-03-21

- catchup with androids new function definitions

## [1.1.2] - 2023-03-17

- bump iOS version to 1.10.0

## [1.1.1] - 2023-02-22

- ignore deprecated usage in test

## [1.1.0] - 2023-02-22

- rename `environmentKey` to `sdkKey` for consistency across SDKs
- bump iOS version to 1.9.1
- bump Android version to 1.4.0

## [1.0.2] - 2023-02-3

- bump iOS version to 1.9.0

## [1.0.1] - 2023-02-1

- bump Android version to 1.2.4

## [1.0.0] - 2023-01-16

- First supported release of DevCycle Flutter Client SDK. Supports Android and iOS.

## [0.0.2] - 2023-01-16

- bump iOS version

## [0.0.1] - 2023-01-13

- Initial Publish
