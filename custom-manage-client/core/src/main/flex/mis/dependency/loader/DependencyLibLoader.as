/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.loader {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;

import mis.dependency.domain.DependencyLibItem;

public class DependencyLibLoader extends Loader {
  private var _dependencyLibItem:DependencyLibItem;

  public function DependencyLibLoader(dependencyLibItem:DependencyLibItem) {
    _dependencyLibItem = dependencyLibItem;
  }


  public function get dependencyLibItem():DependencyLibItem {
    return _dependencyLibItem;
  }

  public function loadLib():void {
    var urlRequest:URLRequest = new URLRequest(dependencyLibItem.artifactId.replace("custom", "rsl") + "-" + dependencyLibItem.version + ".swf");
    contentLoaderInfo.addEventListener(Event.COMPLETE, loaderDependencyLibCompleteHandler);
    contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderDependencyLibErrorHandler);
    load(urlRequest, new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
  }


  private function loaderDependencyLibErrorHandler(event:IOErrorEvent):void {
    trace("can`t load lib dependency: " + event.text);
    var loaderInfo:LoaderInfo = LoaderInfo(event.target);
    loaderInfo.removeEventListener(Event.COMPLETE, loaderDependencyLibCompleteHandler);
    loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderDependencyLibErrorHandler);
  }

  private function loaderDependencyLibCompleteHandler(event:Event):void {
    var loaderInfo:LoaderInfo = LoaderInfo(event.target);
    var dependencyLibLoader:DependencyLibLoader = DependencyLibLoader(loaderInfo.loader);
    dependencyLibLoader.removeEventListener(Event.COMPLETE, loaderDependencyLibCompleteHandler);
    dependencyLibLoader.removeEventListener(IOErrorEvent.IO_ERROR, loaderDependencyLibErrorHandler);
    dependencyLibLoader.dependencyLibItem.applyAllLoadCompleteHandlers();
  }
}
}
