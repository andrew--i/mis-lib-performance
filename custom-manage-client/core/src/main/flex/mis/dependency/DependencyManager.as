/**
 * Created by Andrew on 19.09.2014.
 */
package mis.dependency {
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;

import mis.dependency.domain.DependencyContext;
import mis.dependency.domain.DependencyItem;
import mis.dependency.domain.DependencyLibItem;
import mis.dependency.domain.DependencyMap;
import mis.dependency.loader.DependencyLibLoader;
import mis.dependency.loader.DependencyMapLoader;

public class DependencyManager {

  private var loadedLibs:Vector.<DependencyLibItem> = new <DependencyLibItem>[];
  private var dependenciesMaps:Vector.<DependencyMap> = new <DependencyMap>[];

  public function checkModuleDependency(dependencyContext:DependencyContext):void {
    var moduleDepsMap:DependencyMap = getDependencyMapForModule(dependencyContext.moduleName);
    if (moduleDepsMap != null) {
      waitingForDepsLoading(moduleDepsMap, dependencyContext);
    } else {
      loadDependencyMap(dependencyContext);
    }
  }

  private function loadDependencyMap(dependencyContext:DependencyContext):void {
    var urlLoader:DependencyMapLoader = new DependencyMapLoader(dependencyContext);
    urlLoader.addEventListener(Event.COMPLETE, dependencyMapLoadComplete);
    urlLoader.addEventListener(IOErrorEvent.IO_ERROR, dependencyMapLoadError);
    urlLoader.loadDependencyMap()
  }

  private function dependencyMapLoadError(event:IOErrorEvent):void {
    trace("can`t load module dependency map: " + event.text);
    var dependencyMapLoader:DependencyMapLoader = DependencyMapLoader(event.target);
    dependencyMapLoader.removeEventListener(Event.COMPLETE, dependencyMapLoadComplete);
    dependencyMapLoader.removeEventListener(IOErrorEvent.IO_ERROR, dependencyMapLoadError);

  }

  private function dependencyMapLoadComplete(event:Event):void {
    var dependencyMapLoader:DependencyMapLoader = DependencyMapLoader(event.target);
    dependencyMapLoader.removeEventListener(Event.COMPLETE, dependencyMapLoadComplete);
    dependencyMapLoader.removeEventListener(IOErrorEvent.IO_ERROR, dependencyMapLoadError);

    var dependencyJSONMap:Array = Array(JSON.parse(dependencyMapLoader.data));

    var dependencyContext:DependencyContext = dependencyMapLoader.dependencyContext;
    var dependencyMap:DependencyMap = new DependencyMap(dependencyContext.moduleName);
    for each (var objects:Array in dependencyJSONMap) {
      for each (var item:* in objects) {
        var dependencyItem:DependencyItem = new DependencyItem(item.artifactId, item.version);
        dependencyMap.addDependencyItem(dependencyItem);
      }
    }
    dependenciesMaps.push(dependencyMap);
    waitingForDepsLoading(dependencyMap, dependencyContext)
  }

  private function waitingForDepsLoading(moduleDepsMap:DependencyMap, dependencyContext:DependencyContext):void {
    var dependencyItems:Vector.<DependencyItem> = moduleDepsMap.dependencyItems;
    var loadedLibsCount:uint = 0;
    for each (var item:DependencyItem in dependencyItems) {
      var dependencyLibItem:DependencyLibItem = getDependencyLibItem(item);
      if (dependencyLibItem == null) {
        loadDependencyLibItem(item, dependencyContext)
      } else {
        if (dependencyLibItem.isLoading)
          dependencyLibItem.addCompleteLoadingHandler(dependencyLibItemCompleteHandler, dependencyContext);
        else if (dependencyLibItem.isLoaded)
          loadedLibsCount++;
      }
    }
    if (loadedLibsCount == dependencyItems.length) {
      dependencyContext.dependenciesForModuleReady();
    }

  }

  private function dependencyLibItemCompleteHandler(dependencyContext:DependencyContext):void {
    checkModuleDependency(dependencyContext);
  }

  private function loadDependencyLibItem(dependencyItem:DependencyItem, dependencyContext:DependencyContext):void {
    var dependencyLibItem:DependencyLibItem = new DependencyLibItem(dependencyItem.artifactId, dependencyItem.version);
    loadedLibs.push(dependencyLibItem);
    dependencyLibItem.addCompleteLoadingHandler(dependencyLibItemCompleteHandler, dependencyContext);
    var loader:DependencyLibLoader = new DependencyLibLoader(dependencyLibItem);
    loader.loadLib();
  }

  private function getDependencyLibItem(item:DependencyItem):DependencyLibItem {
    for each (var libItem:DependencyLibItem in loadedLibs) {
      if (libItem.isSameDependencyItem(item)) {
        return libItem;
      }
    }
    return null;
  }

  private function getDependencyMapForModule(moduleName:String):DependencyMap {
    for each (var depsMap:DependencyMap in dependenciesMaps) {
      if (depsMap.moduleName == moduleName)
        return depsMap
    }
    return null;
  }
}
}
