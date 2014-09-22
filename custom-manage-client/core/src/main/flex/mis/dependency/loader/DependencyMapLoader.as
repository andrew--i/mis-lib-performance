/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.loader {
import flash.net.URLLoader;
import flash.net.URLRequest;

import mis.dependency.domain.DependencyContext;

public class DependencyMapLoader extends URLLoader {
  private var _dependencyContext:DependencyContext;

  public function DependencyMapLoader(dependencyContext:DependencyContext) {
    _dependencyContext = dependencyContext;
  }

  public function get dependencyContext():DependencyContext {
    return _dependencyContext;
  }


  public function loadDependencyMap():void {
    var urlRequest:URLRequest = new URLRequest("dependencyMap/" + dependencyContext.moduleName + "-depsmap.json");
    load(urlRequest)
  }
}
}
