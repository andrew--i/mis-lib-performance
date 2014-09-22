/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain {
import mx.core.IVisualElementContainer;

public class DependencyContext {
  private var _moduleName:String;
  private var _container:IVisualElementContainer;
  private var _loadModuleToApp:Function;

  public function DependencyContext(moduleName:String, container:IVisualElementContainer, loadModuleToApp:Function) {
    _moduleName = moduleName;
    _container = container;
    _loadModuleToApp = loadModuleToApp;
  }


  public function get moduleName():String {
    return _moduleName;
  }

  public function get container():IVisualElementContainer {
    return _container;
  }

  public function get loadModuleToApp():Function {
    return _loadModuleToApp;
  }

  public function dependenciesForModuleReady():void {
    _loadModuleToApp(this);
  }
}
}
