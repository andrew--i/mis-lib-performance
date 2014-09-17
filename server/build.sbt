name := "apikeeper"

version := "1.0"

scalaVersion := "2.11.1"

val sprayVersion = "1.3.1"
val specs2Version = "2.3.13"


resolvers += "spray repo" at "http://repo.spray.io"

libraryDependencies ++= Seq(
  "io.spray" %% "spray-can" % sprayVersion,
  "io.spray" %% "spray-routing" % sprayVersion,
  "io.spray" %% "spray-testkit" % sprayVersion % "test",
  "org.specs2" %% "specs2" % specs2Version % "test",
  "com.typesafe.akka" %% "akka-actor" % "2.3.4")

