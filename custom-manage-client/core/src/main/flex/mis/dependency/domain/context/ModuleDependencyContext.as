/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain.context {
import mx.core.IVisualElementContainer;

public class ModuleDependencyContext extends DependencyContext {
  private var _moduleName:String;
  private var _container:IVisualElementContainer;


  public function ModuleDependencyContext(moduleName:String, container:IVisualElementContainer, loadModuleToApp:Function) {
    super(loadModuleToApp);
    _moduleName = moduleName;
    _container = container;
  }


  public function get moduleName():String {
    return _moduleName;
  }

  public function get container():IVisualElementContainer {
    return _container;
  }

}
}
