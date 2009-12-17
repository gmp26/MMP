package org.maths.render
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
		
	
	public class Latex2swf extends Sprite //extends Container
	{
		public var serviceURL:String = 'http://nrich.maths.org/cgi-bin/latex2swf.cgi';
		public var loader:Loader;
		
		function Latex2swf() {
			loader = new Loader();
			addChild(loader);
			configureListeners(loader.contentLoaderInfo);
		}
		
		public function load(tex:String):void {

			var url:String = serviceURL;
			var params:URLVariables = new URLVariables('tex='+ encodeURI(tex));
			var request:URLRequest = new URLRequest(url);
			request.data = params;
			loader.load(request);			
		}
		
		/**
		 * Clean up  
		 */
		public function remove():void {
			removeListeners(loader.contentLoaderInfo);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(Event.INIT, initHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function initHandler(event:Event):void {
			trace("initHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function unLoadHandler(event:Event):void {
			trace("unLoadHandler: " + event);
		}
		
		private function clickHandler(event:MouseEvent):void {
			trace("clickHandler: " + event);
			//var loader:Loader = Loader(event.target);
			//loader.unload();
		}	
	}
}