/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain {
public class DependencyMap {
  private var _dependencyItems:Vector.<DependencyItem> = new <DependencyItem>[];

  private var _moduleName:String;

  public function DependencyMap(moduleName:String) {
    _moduleName = moduleName;

  }

  public function get moduleName():String {
    return _moduleName;
  }

  public function get dependencyItems():Vector.<DependencyItem> {
    return _dependencyItems;
  }

  public function addDependencyItem(dependencyItem:DependencyItem):void {
    _dependencyItems.push(dependencyItem)
  }
}
}
