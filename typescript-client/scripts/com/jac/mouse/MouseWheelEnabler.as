package com.jac.mouse
{
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.utils.getTimer;
   
   public class MouseWheelEnabler
   {
      
      private static var initialised:Boolean = false;
      
      private static var currentItem:InteractiveObject;
      
      private static var browserMouseEvent:MouseEvent;
      
      private static var lastEventTime:uint = 0;
      
      public static var useRawValues:Boolean;
      
      public static var eventTimeout:Number = 50;
       
      
      public function MouseWheelEnabler()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:Boolean = false) : void
      {
         if(!initialised)
         {
            initialised = true;
            print("init mousewheel");
            registerListenerForMouseMove(param1);
            registerJS();
         }
         useRawValues = param2;
      }
      
      private static function registerListenerForMouseMove(param1:Stage) : void
      {
         var stage:Stage = param1;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,function(param1:MouseEvent):void
         {
            currentItem = InteractiveObject(param1.target);
            browserMouseEvent = MouseEvent(param1);
         });
      }
      
      private static function registerJS() : void
      {
         var id:String = null;
         if(ExternalInterface.available)
         {
            id = "mws_" + Math.floor(Math.random() * 1000000);
            ExternalInterface.addCallback(id,function():void
            {
            });
            ExternalInterface.call(MouseWheelEnabler_JavaScript.CODE);
            ExternalInterface.call("mws.InitMouseWheelSupport",id);
            ExternalInterface.addCallback("externalMouseEvent",handleExternalMouseEvent);
         }
      }
      
      private static function handleExternalMouseEvent(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint;
         if((_loc4_ = uint(getTimer())) >= eventTimeout + lastEventTime)
         {
            if(useRawValues)
            {
               _loc3_ = param1;
            }
            else
            {
               _loc3_ = param2;
            }
            if(Boolean(currentItem) && Boolean(browserMouseEvent))
            {
               currentItem.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL,true,false,browserMouseEvent.localX,browserMouseEvent.localY,browserMouseEvent.relatedObject,browserMouseEvent.ctrlKey,browserMouseEvent.altKey,browserMouseEvent.shiftKey,browserMouseEvent.buttonDown,int(_loc3_)));
            }
            lastEventTime = _loc4_;
         }
      }
      
      public static function getBrowserInfo() : BrowserInfo
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = ExternalInterface.call("mws.getBrowserInfo");
            _loc2_ = ExternalInterface.call("mws.getPlatformInfo");
            _loc3_ = ExternalInterface.call("mws.getAgentInfo");
            return new BrowserInfo(_loc1_,_loc2_,_loc3_);
         }
         return null;
      }
   }
}

class MouseWheelEnabler_JavaScript
{
   
   public static const CODE:XML = <script><![CDATA[
		function()
		{
			// create unique namespace
			if(typeof mws == "undefined" || !mws)	
			{
				mws = {};
			}
			
			var userAgent = navigator.userAgent.toLowerCase();
			mws.agent = userAgent;
			mws.platform = 
			{
				win:/win/.test(userAgent),
				mac:/mac/.test(userAgent),
				other:!/win/.test(userAgent) && !/mac/.test(userAgent)
			};
			
			mws.vars = {};
			
			mws.browser = 
			{
				version: (userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1],
				safari: /webkit/.test(userAgent) && !/chrome/.test(userAgent),
				opera: /opera/.test(userAgent),
				msie: /msie/.test(userAgent) && !/opera/.test(userAgent),
				mozilla: /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent),
				chrome: /chrome/.test(userAgent)
			};
			
			// find the function we added
			mws.findSwf = function(id) 
			{
				var objects = document.getElementsByTagName("object");
				for(var i = 0; i < objects.length; i++)
				{
					if(typeof objects[i][id] != "undefined")
					{
						return objects[i];
					}
				}
				
				var embeds = document.getElementsByTagName("embed");
				
				for(var j = 0; j < embeds.length; j++)
				{
					if(typeof embeds[j][id] != "undefined")
					{
						return embeds[j];
					}
				}
					
				return null;
			}
			
			mws.usingWmode = function( swf )
			{
				if( typeof swf.getAttribute == "undefined" )
				{
					return false;
				}
				
				var wmode = swf.getAttribute( "wmode" );
				if( typeof wmode == "undefined" )
				{
					return false;
				}
				
				return true;
			}
			
			//Debug logging
			mws.log = function( message ) 
			{
				if( typeof console != "undefined" )
				{
					console.log( message );
				}
				else
				{
					//alert( message );
				}
			}
			
			mws.shouldAddHandler = function( swf )
			{
				if( !swf )
				{
					return false;
				}
				
				return true;
			}
			
			mws.getBrowserInfo = function()
			{//getBrowserObj
				return mws.browser;
			}//getBrowserObj
			
			mws.getAgentInfo = function()
			{//getAgentInfo
				return mws.agent;
			}//getAgentInfo
			
			mws.getPlatformInfo = function()
			{//getPlatformInfo
				return mws.platform;
			}//getPlatformInfo
			
			mws.addScrollListeners = function()
			{//addScrollListeners
				
				// install mouse listeners
				if(typeof window.addEventListener != 'undefined') 
				{
					window.addEventListener('DOMMouseScroll', _mousewheel, false);
				}
				
				window.onmousewheel = document.onmousewheel = _mousewheel;
				
			}//addScrollListeners
			
			mws.removeScrollListeners = function()
			{//removeScrollListeners
				// install mouse listeners
				if(typeof window.removeEventListener != 'undefined') 
				{
					window.removeEventListener('DOMMouseScroll', _mousewheel, false);
				}
				
				window.onmousewheel = document.onmousewheel = null;
			}//removeScrollListeners
			
			mws.InitMouseWheelSupport = function(id) 
			{//InitMouseWheelSupport
				//grab reference to the swf
				var swf = mws.findSwf(id);
				
				//see if we can add the mouse listeners
				var shouldAdd = mws.shouldAddHandler( swf );
				
				if( shouldAdd ) 
				{
					/// Mousewheel support
					_mousewheel = function(event) 
					{//Mouse Wheel
							
						//Cover for IE
						if (!event) event = window.event;
						
						var rawDelta = 0;
						var divisor = 1;
						var scaledDelta = 0;
						
						//Handle scaling the delta.
						//This is becoming less and less useful as more browser/hardware combos emerge.
						if(event.wheelDelta)	
						{//normal event
							rawDelta = event.wheelDelta;
							
							if(mws.browser.opera)
							{
								divisor = 12;
							}
							else if(mws.browser.safari && mws.browser.version.split(".")[0] >= 528)
							{
								divisor = 12;
							}
							else
							{
								divisor = 120;
							}
						}//normal event
						else if(event.detail)		
						{//special event
							rawDelta = -event.detail;
						}//special event
						else
						{//odd event
							//Unhandled event type (future browser graceful fail)
							rawDelta = 0;
							scaledDelta = 0;
							
							//alert('Odd Event');
						}//odd event
						
						if(Math.abs(rawDelta) >= divisor)
						{//divide
							scaledDelta = rawDelta/divisor;
						}//divide
						else
						{//don't scale
							scaledDelta = rawDelta;
						}//don't scale
						
						//Call into the swf to fire a mouse event
						swf.externalMouseEvent(rawDelta, scaledDelta);
						
						if(event.preventDefault)	
						{//Stop default action
							event.preventDefault();
						}//Stop default action
						else
						{//stop default action (IE)
							return false;
						}//stop default action (IE)
							
						return true;
					}//MouseWheel

					//set up listeners
					swf.onmouseover = mws.addScrollListeners;
					swf.onmouseout = mws.removeScrollListeners;
				}//Should Add
					
			}//InitMouseWheelSupport
			
		}
	]]></script>;
    
   
   public function MouseWheelEnabler_JavaScript()
   {
      super();
   }
}
