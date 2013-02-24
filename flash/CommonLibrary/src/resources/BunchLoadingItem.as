
package resources {
	
import flash.net.URLVariables;

public class BunchLoadingItem {
    private var _url:String;
    private var _shortId:String;
    private var _preventCache:Boolean;
    private var _isPost:Boolean;
    private var _postData:URLVariables;
    private var _isBinary:Boolean;
	
    public function BunchLoadingItem(url:String, shortId:String, preventCache:Boolean,
                                          isPost:Boolean, isBinary:Boolean, postData:URLVariables) {
        _url = url;
        _shortId = shortId;
        _preventCache = preventCache;
        _isPost = isPost;
        _postData = postData;
        _isBinary = isBinary;
    }

    public function get url():String {
        return _url;
    }

    public function get shortId():String {
        return _shortId;
    }

    public function get preventCache():Boolean {
        return _preventCache;
    }

    public function get isPost():Boolean {
        return _isPost;
    }

    public function get postData():URLVariables {
        return _postData;
    }

    public function get isBinary():Boolean {
        return _isBinary;
    }

	

}
}
