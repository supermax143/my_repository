package social.vkontakte.loaders
{
	import flash.utils.ByteArray;
	
	public class MultipartData {
		
		public static const BOUNDARY:String = "----------cH2gL6ei4Ef1gL6GI3Ij5Ef1Ef1Ef1";
		private static const CRLF:String = "\r\n";
		private static const HYPHENS:String = "--";
		
		private var _data:ByteArray = new ByteArray();
		
		public function get data():ByteArray {
			var d:ByteArray = new ByteArray();
			d.writeBytes(_data);
			d.writeUTFBytes(HYPHENS + BOUNDARY + HYPHENS);
			return d;
		}
		
		public function addFile(file:ByteArray, name:String, fileName:String = "name.jpg"):void {
			_data.writeUTFBytes(HYPHENS + BOUNDARY + CRLF);
			_data.writeUTFBytes("Content-Disposition: form-data; name=" + name + "; filename=" + fileName + CRLF);
			//            _data.writeUTFBytes("Content-Disposition: form-data; name=" + name + CRLF); без filename возвращает invalid photo
			_data.writeUTFBytes("Content-Type: application/octet-stream" + CRLF + CRLF);
			_data.writeBytes(file);
			_data.writeUTFBytes(CRLF);
		}
		
		public function clear():void {
			_data.clear();
		}
		
	}

}