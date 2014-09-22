/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain.context {
import mis.dependency.domain.*;

public class LibDependencyContext extends DependencyContext {
  private var _item:DependencyItem;
  private var _moduleContext:ModuleDependencyContext;

  public function LibDependencyContext(item:DependencyItem, moduleContext:ModuleDependencyContext, dependencyContextReady:Function) {
    super(dependencyContextReady);
    _item = item;
    _moduleContext = moduleContext;
  }


  public function get item():DependencyItem {
    return _item;
  }

  public function get moduleContext():ModuleDependencyContext {
    return _moduleContext;
  }
}
}
