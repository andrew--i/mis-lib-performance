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
  private val indexPath = path("") | path("index.html")
  def route: Route = {
    indexPath {
      get {
        respondWithMediaType(MediaTypes.`text/html`) {
          getFromFile("resources/index.html")
        }
      }
    } ~
      path("swfobject.js") {
        get {
          getFromFile("resources/swfobject.js")
        }
      } ~
      path("rsls" / Rest) { resource ⇒
        get {
          getFromFile("resources/" + resource)
        }
      } ~
      path(Rest) { resource ⇒
        get {
          if (resource.endsWith("swc") || resource.endsWith("swf"))
            getFromFile("resources/" + resource)
          else
            complete("resource " + resource + "does not exist")
        }
      }
  }
}
