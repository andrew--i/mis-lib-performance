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
    get {
      indexPath {
        respondWithMediaType(MediaTypes.`text/html`) {
          getFromFile("resources/index.html")
        }
      } ~ path("rsls" / Rest) { resource ⇒
        getFromFile("resources/" + resource)
      } ~ path("history" / Rest) { resource ⇒
        getFromFile("resources/history" + resource)
      } ~ path("dependencyMap" / Rest) { resource ⇒
        getFromFile("resources/" + resource)
      } ~ path(Rest) { resource ⇒
        getFromFile("resources/" + resource)
      }
    }
  }
}
