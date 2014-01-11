import android.Keys._

android.Plugin.androidBuild

name := "hello-scaloid-sbt"

scalaVersion := "2.10.3"

proguardCache in Android ++= Seq(
  ProguardCache("org.scaloid") % "org.scaloid"
)

proguardOptions in Android ++= Seq("-dontobfuscate", "-dontoptimize")

libraryDependencies += "org.scaloid" %% "scaloid" % "3.1-8-RC1"

scalacOptions in Compile += "-feature"

run <<= run in Android

install <<= install in Android
