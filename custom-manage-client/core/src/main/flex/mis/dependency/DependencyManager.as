/**
 * Created by Andrew on 19.09.2014.
 */
package mis.dependency {
import flash.events.Event;

import mis.dependency.domain.DependencyItem;
import mis.dependency.domain.DependencyLibItem;
import mis.dependency.domain.DependencyMap;
import mis.dependency.domain.context.DependencyContext;
import mis.dependency.domain.context.LibDependencyContext;
import mis.dependency.domain.context.LibDependencyContext;
import mis.dependency.domain.context.ModuleDependencyContext;
import mis.dependency.loader.DependencyLibLoader;
import mis.dependency.loader.LibDependencyMapLoader;
import mis.dependency.loader.ModuleDependencyMapLoader;

public class DependencyManager {

  private var loadedLibs:Vector.<DependencyLibItem> = new <DependencyLibItem>[];
  private var dependenciesMaps:Vector.<DependencyMap> = new <DependencyMap>[];

  public function checkModuleDependency(dependencyContext:DependencyContext):void {
    var moduleDepsMap:DependencyMap = getDependencyMapForModule(dependencyContext.moduleName);
    if (moduleDepsMap != null) {
      waitingForDependenciesLoading(moduleDepsMap, dependencyContext);
    } else {
      loadDependencyMap(dependencyContext);
    }
  }

  private function loadDependencyMap(dependencyContext:DependencyContext):void {
    var urlLoader:* = null;
    if (dependencyContext instanceof ModuleDependencyContext) {
      urlLoader = new ModuleDependencyMapLoader(ModuleDependencyContext(dependencyContext));
    } else {
      urlLoader = new LibDependencyMapLoader(LibDependencyContext(dependencyContext));
    }
    urlLoader.addEventListener(ModuleDependencyMapLoader.MAP_DEPENDENCY_READY, urlLoader_MODULE_DEPENDENCY_READYHandler);
    urlLoader.loadDependencyMap()
  }

  private function urlLoader_MODULE_DEPENDENCY_READYHandler(event:Event):void {
    var moduleDependencyMapLoader:ModuleDependencyMapLoader = ModuleDependencyMapLoader(event.target);
    moduleDependencyMapLoader.removeEventListener(ModuleDependencyMapLoader.MAP_DEPENDENCY_READY, urlLoader_MODULE_DEPENDENCY_READYHandler);
    var dependencyMap:DependencyMap = moduleDependencyMapLoader.dependencyMap;
    dependenciesMaps.push(dependencyMap);
    waitingForDependenciesLoading(dependencyMap, moduleDependencyMapLoader.dependencyContext)
  }


  private function waitingForDependenciesLoading(moduleDependenciesMap:DependencyMap, dependencyContext:DependencyContext):void {
    var dependencyItems:Vector.<DependencyItem> = moduleDependenciesMap.dependencyItems;
    var loadedLibsCount:uint = 0;
    for each (var item:DependencyItem in dependencyItems) {
      var dependencyLibItem:DependencyLibItem = getDependencyLibItem(item);
      if (dependencyLibItem == null) {
        loadDependencyMap(new LibDependencyContext(item, dependencyContext, loadDependencyLibItem));
      } else {
        if (dependencyLibItem.isLoading)
          dependencyLibItem.addCompleteLoadingHandler(dependencyLibItemCompleteHandler, dependencyContext);
        else if (dependencyLibItem.isLoaded)
          loadedLibsCount++;
      }
    }
    if (loadedLibsCount == dependencyItems.length) {
      dependencyContext.dependenciesContextReady();
    }
  }


  private function dependencyLibItemCompleteHandler(dependencyContext:DependencyContext):void {
    checkModuleDependency(dependencyContext);
  }

  private function loadDependencyLibItem(libDependencyContext:LibDependencyContext):void {
    var dependencyItem:DependencyItem = libDependencyContext.item;
    var dependencyContext:DependencyContext = libDependencyContext.parentDependencyContext;
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
