/**
 * Created by Andrew on 19.09.2014.
 */
package mis.dependency {
import mis.dependency.domain.context.ModuleDependencyContext;

import mx.core.IVisualElementContainer;
import mx.events.ModuleEvent;

import spark.modules.ModuleLoader;

public class ModuleManager {
  private var loadedModules:Array = [];
  private var dependencyManager:DependencyManager = new DependencyManager();

  private static var _instance:ModuleManager;
  public static function get instance():ModuleManager {
    if (_instance == null)
      _instance = new ModuleManager();
    return _instance;
  }

  private function getLoadedModule(moduleName:String):ModuleLoader {
    for each (var info:* in loadedModules) {
      if (info.name == moduleName)
        return info.loader;
    }
    return null;
  }

  private function addLoadedModule(moduleName:String, moduleLoader:ModuleLoader):void {
    loadedModules.push({name: moduleName, loader: moduleLoader})
  }

  public function loadModule(toContainer:IVisualElementContainer, moduleName:String):void {
    var loadedModule:ModuleLoader = getLoadedModule(moduleName);
    if (loadedModule != null)
      return;
    dependencyManager.checkModuleDependency(new ModuleDependencyContext(moduleName, toContainer, loadModuleToApp))
  }

  private function loadModuleToApp(dependencyContext:ModuleDependencyContext):void {
    var moduleLoader:ModuleLoader = new ModuleLoader();
    addLoadedModule(dependencyContext.moduleName, moduleLoader);
    moduleLoader.addEventListener(ModuleEvent.ERROR, moduleLoader_errorHandler);
    moduleLoader.addEventListener(ModuleEvent.READY, moduleLoader_readyHandler);
    dependencyContext.container.addElement(moduleLoader);
    moduleLoader.loadModule(dependencyContext.moduleName)
  }

  private function moduleLoader_errorHandler(event:ModuleEvent):void {
    var moduleLoader:ModuleLoader = ModuleLoader(event.target);
    moduleLoader.removeEventListener(ModuleEvent.ERROR, moduleLoader_errorHandler);
    moduleLoader.removeEventListener(ModuleEvent.READY, moduleLoader_readyHandler);
    trace("module load error : " + event.errorText)
  }

  private function moduleLoader_readyHandler(event:ModuleEvent):void {
    var moduleLoader:ModuleLoader = ModuleLoader(event.target);
    moduleLoader.removeEventListener(ModuleEvent.ERROR, moduleLoader_errorHandler);
    moduleLoader.removeEventListener(ModuleEvent.READY, moduleLoader_readyHandler);
    trace("module ready : " + event.module.ready)
  }
}
}
