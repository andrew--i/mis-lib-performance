/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain.context {
import mis.dependency.domain.*;

public class LibDependencyContext extends DependencyContext {
  private var _item:DependencyItem;
  private var _parentDependencyContext:DependencyContext;

  public function LibDependencyContext(item:DependencyItem, parentDependencyContext:DependencyContext, dependencyContextReady:Function) {
    super(item.artifactId, dependencyContextReady);
    _item = item;
    _parentDependencyContext = parentDependencyContext;
  }

  public function get item():DependencyItem {
    return _item;
  }

  public function get parentDependencyContext():DependencyContext {
    return _parentDependencyContext;
  }
}
}
