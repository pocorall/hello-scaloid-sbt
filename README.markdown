# Hello Scaloid for sbt

This is a template project that can be a starting point of a new [Scaloid](https://github.com/pocorall/scaloid) project. 

This contains minimum code as possible; therefore easy to run, examine and extend.

Prerequisites
-------------
* sbt 0.13.0 or above
* Android SDK

Build
-----
You can build using sbt:

    $ sbt android:package

This will compile the project and generate an APK.

For more command, refer to [Android SDK plugin for sbt](https://github.com/pfn/android-sdk-plugin).



Troubleshooting
---------------

### Build error `Android SDK build-tools not available`
[The most likely cause of this error is that your SDK build-tools are old.](https://github.com/pfn/android-sdk-plugin/issues/13) Update the Android SDK and retry.

Further Reading
---------------
- [Scaloid](https://github.com/pocorall/scaloid)
- [Scaloid APIdemos](https://github.com/pocorall/scaloid-apidemos)
- [Android SDK plugin for sbt](https://github.com/pfn/android-sdk-plugin)

