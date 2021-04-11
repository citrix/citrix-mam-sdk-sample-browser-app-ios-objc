## Description
This repository contains the iOS Objective-C source code for a sample browser app that uses the MAM SDKs for endpoint management.  It does not contain the [MAM SDK](https://docs.citrix.com/en-us/mdx-toolkit/mam-sdk-overview.html) libraries themselves, which are downloaded separately.

## Download
The MAM SDK libraries can be downloaded from [MAM SDKs and Toolkit](https://www.citrix.com/downloads/citrix-endpoint-management/product-software/mdx-toolkit.html).

## Documentation

For detailed documentation on how to use this sample app, and compile it, see the [MAM SDK for iOS and iPadOS Overview](https://developer.cloud.com/citrixworkspace/mobile-application-integration/mam-sdk-for-ios-and-ipados/docs/overview).  Documentation is also included in the MAM SDK download package.

## Questions

For questions and support:

-  [StackOverflow [citrix] [mdm] tags](https://stackoverflow.com/questions/tagged/mdm+citrix)
-  [Citrix Discussion Forum](https://discussions.citrix.com/forum/1797-mobile-app-management-mam/)

## Contribute

The "master" branch is only intended to be used for releases, and will always be compatible with the MAM SDK binaries. The "master" branch is not intended to be used by developers. This follows
the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) model.

The "develop" branch is the main branch that developers will use. It is compatible with the latest in-progress MAM SDK binaries, and hence might not compile with the official public MAM SDK binaries.

To contribute you can create a feature branch off of "develop", if you have access, and then create a PR to merge back to "develop" (with approval).  If you're not a Citrix developer then you likely don't have access, and in that case to contribute you'll first create a fork of the code, make your changes in your fork, then create a cross-repo PR to suggest your changes for inclusion to the "develop" branch in this repo.

## License

[MIT License](./LICENSE)
