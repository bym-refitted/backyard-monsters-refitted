package
{
   import com.monsters.debug.Console;
   import flash.events.*;
   import flash.text.TextFieldAutoSize;
   import gs.*;
   import gs.easing.*;
   
   public class MESSAGE extends MESSAGE_CLIP
   {
       
      
      public var _mc:MESSAGE_CLIP;
      
      public var _action:Function;
      
      public var _action2:Function;
      
      public var _args:Array;
      
      public var _args2:Array;
      
      public function MESSAGE()
      {
         super();
      }
      
      public function Show(param1:String = null, param2:String = null, param3:Function = null, param4:Array = null, param5:String = null, param6:Function = null, param7:Array = null, param8:int = 1, param9:Boolean = true) : MESSAGE
      {
         this._action = param3;
         this._action2 = param6;
         this._args = param4;
         this._args2 = param7;
         tMessage.autoSize = TextFieldAutoSize.CENTER;
         tMessage.htmlText = param1;
         mcBG.height = tMessage.height + 45;
         if(param2)
         {
            bAction.Setup(param2);
            bAction.addEventListener(MouseEvent.CLICK,this.Action);
            mcBG.height += 30;
         }
         else
         {
            bAction.visible = false;
         }
         if(param5)
         {
            bAction2.Setup(param5);
            bAction2.addEventListener(MouseEvent.CLICK,this.Action2);
            mcBG.height += 30;
         }
         else
         {
            bAction2.visible = false;
         }
         mcBG.y = 0 - int(mcBG.height * 0.5);
         mcBG.Setup(param9);
         tMessage.y = mcBG.y + 20;
         bAction.y = mcBG.y + mcBG.height - 45;
         bAction2.y = mcBG.y + mcBG.height - 45;
         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         this._mc = GLOBAL._layerTop.addChild(this) as MESSAGE_CLIP;
         this._mc.Center();
         this._mc.ScaleUp();
         return this;
      }
      
      public function Action(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.Hide();
         if(Boolean(this._action))
         {
            try
            {
               if(!this._args)
               {
                  this._action();
               }
               else if(this._args.length == 1)
               {
                  this._action(this._args[0]);
               }
               else if(this._args.length == 2)
               {
                  this._action(this._args[0],this._args[1]);
               }
               else if(this._args.length == 3)
               {
                  this._action(this._args[0],this._args[1],this._args[2]);
               }
               else if(this._args.length == 4)
               {
                  this._action(this._args[0],this._args[1],this._args[2],this._args[3]);
               }
               else
               {
                  print("ERROR: MESSAGE.Action only handles up to 4 parameters! (cause its programmed funky)");
               }
            }
            catch(error:Error)
            {
               Console.warning(error + "MESSAGE.Action (invalid action and/or arguments)",true);
            }
         }
      }
      
      public function Action2(param1:MouseEvent) : void
      {
         this.Hide();
         if(Boolean(this._action2))
         {
            if(!this._args2)
            {
               this._action2();
            }
            else if(this._args2.length == 1)
            {
               this._action2(this._args2[0]);
            }
            else if(this._args2.length == 2)
            {
               this._action2(this._args2[0],this._args2[1]);
            }
            else if(this._args2.length == 3)
            {
               this._action2(this._args2[0],this._args2[1],this._args2[2]);
            }
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         GLOBAL.BlockerRemove();
         SOUNDS.Play("close");
         if(Boolean(this._mc) && Boolean(this._mc.parent))
         {
            GLOBAL._layerTop.removeChild(this._mc);
         }
         this._mc = null;
      }
      
      public function Resize() : void
      {
         if(GLOBAL._SCREENCENTER)
         {
            this._mc.x = GLOBAL._SCREENCENTER.x;
            this._mc.y = GLOBAL._SCREENCENTER.y;
         }
         else
         {
            this._mc.x = GLOBAL._SCREENINIT.width / 2;
            this._mc.y = GLOBAL._SCREENINIT.height / 2;
         }
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}
