package mis

import akka.actor.{ActorSystem, Props}
import akka.io.IO
import spray.can.Http
import spray.http.MediaTypes
import spray.routing.{HttpServiceActor, Route}


object Server {
  def main(args: Array[String]) {
    implicit val system = ActorSystem("mis-client-performance-test-service")
    IO(Http) ! Http.Bind(system.actorOf(Props[Service]), interface = "localhost", port = 8080)
  }
}

class Service extends HttpServiceActor {
  override def receive: Receive = runRoute(route)

  def route: Route = {
    path("") {
      get {
        respondWithMediaType(MediaTypes.`text/html`) {
          getFromResource("index.html")
        }
      }
    } ~
      path("swfobject.js") {
        get {
          getFromResource("swfobject.js")
        }
      } ~
      path("rsls" / Rest) { resource ⇒
        get {
          getFromResource(resource)
        }
      } ~
      path(Rest) { resource ⇒
        get {
          if (resource.endsWith("swc") || resource.endsWith("swf"))
            getFromResource(resource)
          else
            complete("resource " + resource + "does not exist")
        }
      }
  }
}
