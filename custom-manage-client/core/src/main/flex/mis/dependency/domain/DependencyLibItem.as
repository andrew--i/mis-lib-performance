/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain {
public class DependencyLibItem extends DependencyItem {
  private var _isLoading:Boolean = false;
  private var _isLoaded:Boolean = false;
  private var completeHandlers:Array = [];

  public function DependencyLibItem(artifactId:String, version:String) {
    super(artifactId, version);
    _isLoading = true;
  }


  public function get isLoading():Boolean {
    return _isLoading;
  }

  public function get isLoaded():Boolean {
    return _isLoaded;
  }

  public function isSameDependencyItem(item:DependencyItem):Boolean {
    return item.artifactId == artifactId && item.version == version;
  }

  public function addCompleteLoadingHandler(dependencyLibItemCompleteHandler:Function, dependencyContext:DependencyContext):void {
    completeHandlers.push({handler: dependencyLibItemCompleteHandler, arg: dependencyContext})
  }

  public function applyAllLoadCompleteHandlers():void {
    _isLoaded = true;
    _isLoading = false;
    for each (var handler:* in completeHandlers) {
      handler.handler(handler.arg);
    }
    completeHandlers = [];
  }
}
}
