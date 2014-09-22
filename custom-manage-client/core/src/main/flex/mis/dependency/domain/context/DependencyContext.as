/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain.context {
public class DependencyContext {

  private var _dependencyContextReady:Function;


  public function DependencyContext(dependencyContextReady:Function) {
    _dependencyContextReady = dependencyContextReady;
  }

  public function dependenciesForModuleReady():void {
    _dependencyContextReady(this);
  }
}
}
