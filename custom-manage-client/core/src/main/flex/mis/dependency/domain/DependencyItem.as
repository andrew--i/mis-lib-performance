/**
 * Created by Andrew on 22.09.2014.
 */
package mis.dependency.domain {
public class DependencyItem {
  private var _artifactId:String;
  private var _version:String;

  public function DependencyItem(artifactId:String, version:String) {
    _artifactId = artifactId;
    _version = version;
  }


  public function get artifactId():String {
    return _artifactId;
  }

  public function get version():String {
    return _version;
  }
}
}
