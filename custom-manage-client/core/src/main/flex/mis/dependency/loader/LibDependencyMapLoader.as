/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.loader {
import flash.events.IOErrorEvent;
import flash.net.URLLoader;

import mis.dependency.domain.context.LibDependencyContext;

public class LibDependencyMapLoader extends ModuleDependencyMapLoader {

  public function LibDependencyMapLoader(dependencyContext:LibDependencyContext) {
    super(null);
    _dependencyContext = dependencyContext;
  }


  override protected function dependencyMapLoadError(event:IOErrorEvent):void {
    removeListeners(URLLoader(event.target));
    if (event.errorID == 2032) {
      _dependencyContext.dependenciesContextReady();
    } else
      trace("can`t load lib dependency map: " + event.text);
  }
}
}
