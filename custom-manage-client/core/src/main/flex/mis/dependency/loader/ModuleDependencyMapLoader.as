/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.loader {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mis.dependency.domain.DependencyItem;
import mis.dependency.domain.DependencyMap;
import mis.dependency.domain.context.DependencyContext;
import mis.dependency.domain.context.ModuleDependencyContext;

public class ModuleDependencyMapLoader extends URLLoader {
  public static const MAP_DEPENDENCY_READY:String = "MODULE_DEPENDENCY_READY";

  protected var _dependencyContext:DependencyContext;
  protected var _dependencyMap:DependencyMap;


  public function get dependencyMap():DependencyMap {
    return _dependencyMap;
  }

  public function ModuleDependencyMapLoader(dependencyContext:ModuleDependencyContext) {
    _dependencyContext = dependencyContext;
  }

  public function get dependencyContext():DependencyContext {
    return _dependencyContext;
  }


  public function loadDependencyMap():void {
    var urlRequest:URLRequest = new URLRequest("dependencyMap/" + dependencyContext.moduleName + "-depsmap.json");
    addEventListener(Event.COMPLETE, dependencyMapLoadComplete);
    addEventListener(IOErrorEvent.IO_ERROR, dependencyMapLoadError);
    load(urlRequest)
  }


  protected function dependencyMapLoadError(event:IOErrorEvent):void {
    trace("can`t load module dependency map: " + event.text);
    var dependencyMapLoader:URLLoader = URLLoader(event.target);
    removeListeners(dependencyMapLoader);
  }

  protected function dependencyMapLoadComplete(event:Event):void {
    var dependencyMapLoader:ModuleDependencyMapLoader = ModuleDependencyMapLoader(event.target);
    removeListeners(dependencyMapLoader);
    var dependencyJSONMap:Array = Array(JSON.parse(dependencyMapLoader.data));
    var dependencyContext:DependencyContext = dependencyMapLoader.dependencyContext;
    var dependencyMap:DependencyMap = new DependencyMap(dependencyContext.moduleName);
    for each (var objects:Array in dependencyJSONMap) {
      for each (var item:* in objects) {
        var dependencyItem:DependencyItem = new DependencyItem(item.artifactId, item.version);
        dependencyMap.addDependencyItem(dependencyItem);
      }
    }
    _dependencyMap = dependencyMap;
    dispatchEvent(new Event(MAP_DEPENDENCY_READY));
  }

  protected function removeListeners(dependencyMapLoader:URLLoader):void {
    dependencyMapLoader.removeEventListener(Event.COMPLETE, dependencyMapLoadComplete);
    dependencyMapLoader.removeEventListener(IOErrorEvent.IO_ERROR, dependencyMapLoadError);
  }
}
}
