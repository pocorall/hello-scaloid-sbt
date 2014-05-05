# Hello Scaloid for sbt

This is a template project that can be a starting point of a new [Scaloid](https://github.com/pocorall/scaloid) project.

This contains minimum code as possible; therefore easy to run, examine and extend.

Prerequisites
-------------
* sbt 0.13.0 or above
* Android SDK
  - Both SDK Level 10 and the most recent version should be installed.

Build
-----
You can build this project using sbt:

    $ sbt android:package

This will compile the project and generate an APK.

For more command, refer to [android-sdk-plugin for sbt](https://github.com/pfn/android-sdk-plugin).

Tips for faster development iteration
-------------------------------------
In sbt, `~` is a prefix that repeatedly runs the command when the source code is modified.

    ~ android:run
    
This sbt command schedules to execute compile-package-deploy-run process after you save the edited source code.
Compiling and packaging runs incrementally, so this iteration takes about only few seconds.

If you use default AVD, try genymotion or other faster virtual device. Deploying apk to the device becomes much faster!

Using Eclipse
-------------

    $ sbt eclipse

Using IntelliJ IDEA
-------------------    
    
    $ sbt gen-idea

Two more steps are needed for IDEA:

 * Project Structure -> Project -> in Project SDK section, select proper Android SDK
 * Porject Structure -> Modules -> add Android facet to your project module

We do not recommend to use IDEA's own Android build system, because proguard settings are complicated and not fast.
Use commands from [android-sdk-plugin for sbt](https://github.com/pfn/android-sdk-plugin).
It runs simple and fast.

Troubleshooting
---------------

### Build error `Android SDK build-tools not available`
[The most likely cause of this error is that your SDK build-tools are old.](https://github.com/pfn/android-sdk-plugin/issues/13) Update the Android SDK and retry.

Further Reading
---------------
- [Scaloid](https://github.com/pocorall/scaloid)
- [Scaloid APIdemos](https://github.com/pocorall/scaloid-apidemos)
- [Android SDK plugin for sbt](https://github.com/pfn/android-sdk-plugin)

