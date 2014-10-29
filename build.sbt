import android.Keys._

android.Plugin.androidBuild

name := "hello-scaloid-sbt"

scalaVersion := "2.11.3"

proguardCache in Android ++= Seq(
  ProguardCache("org.scaloid") % "org.scaloid"
)

proguardOptions in Android ++= Seq("-dontobfuscate", "-dontoptimize", "-keepattributes Signature"
  , "-dontwarn scala.collection.**" // required from Scala 2.11.3
  , "-dontwarn scala.collection.mutable.**" // required from Scala 2.11.0
)

libraryDependencies += "org.scaloid" %% "scaloid" % "3.6-10" withSources() withJavadoc()

scalacOptions in Compile += "-feature"

run <<= run in Android

install <<= install in Android
