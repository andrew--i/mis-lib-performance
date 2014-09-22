/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain.context {
public class DependencyContext {

  private var _dependencyContextReady:Function;
  private var _moduleName:String;


  public function DependencyContext(moduleName:String, dependencyContextReady:Function) {
    _dependencyContextReady = dependencyContextReady;
    _moduleName = moduleName;
  }

  public function dependenciesContextReady():void {
    _dependencyContextReady(this);
  }

  public function get moduleName():String {
    return _moduleName;
  }
}
}
