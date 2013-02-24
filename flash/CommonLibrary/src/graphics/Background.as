package graphics  {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Background extends Shape {
		private var w : Number;
		private var h : Number;
		private var backgroundColor : Number;
		private var frameColor : Number;
		private var startAlpha : Number;

		//---------------------------------------------------------------------------------------

		public function Background(w : Number = 10, h : Number = 10, backgroundColor : Number = 0, frameColor : Number = -1, alpha : Number = 1.0) {
			this.w = w;
			this.h = h;
			this.backgroundColor = backgroundColor;
			this.frameColor = frameColor;
			this.startAlpha = alpha;
			
			with(this.graphics) {
				beginFill(backgroundColor, alpha);
				if(frameColor != -1) {
					lineStyle(0, frameColor);
				}
				drawRect(0,0,w,h);
				endFill();
			}
		}
		
		public function toSprite(alpha : Number = 1) : Sprite {
			var res: Sprite = GraphixUtils.createSpriteWrapper(this);
			res.alpha = alpha;
			return res;
		}
		
		public function dispose() : void {
			
		}

		public static function fromRectangle(rect : Rectangle, backgroundColor : Number = 0, frameColor : Number = -1, alpha : Number = 1.0) : Background {
			var res : Background = new Background(rect.width, rect.height, backgroundColor, frameColor, alpha);
			res.x = rect.x;
			res.y = rect.y;
			return res;
		}

		public function clone() : Background {
			var res : Background = new Background(w, h, backgroundColor, frameColor, startAlpha);
			
			return res;
		}
	}
}
