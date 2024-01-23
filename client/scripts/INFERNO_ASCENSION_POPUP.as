package
{
   import com.cc.utils.SecNum;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class INFERNO_ASCENSION_POPUP extends InfernoTransferPopup_CLIP
   {
       
      
      private const NUM_MONSTER_ENTRIES:int = 15;
      
      public var _queuedForAscension:Object;
      
      private var _monsterUi:Vector.<InfernoTransferMonster_CLIP>;
      
      private var _monsterUiIds:Vector.<String>;
      
      private var _storageWidth:int;
      
      private var _newHousingUsed:SecNum;
      
      public function INFERNO_ASCENSION_POPUP()
      {
         var i:int;
         this._queuedForAscension = {};
         this._monsterUi = new Vector.<InfernoTransferMonster_CLIP>(this.NUM_MONSTER_ENTRIES,true);
         this._monsterUiIds = new Vector.<String>(this.NUM_MONSTER_ENTRIES,true);
         this._newHousingUsed = new SecNum(0);
         super();
         title_txt.text = KEYS.Get("ascdlg_title");
         capacity_desc_txt.text = KEYS.Get("ascdlg_capacity_desc");
         transfer_action_txt.text = KEYS.Get("ascdlg_transfer_action");
         transfer_desc_txt.text = KEYS.Get("ascdlg_transfer_desc");
         bTransfer.SetupKey("ascdlg_transfer_btn");
         bTransfer.addEventListener(MouseEvent.CLICK,function():void
         {
            AscendQueuedMonsters();
         });
         i = 0;
         while(i < this.NUM_MONSTER_ENTRIES)
         {
            this.SetupSection(this["m" + (i + 1)],i);
            i++;
         }
         this._storageWidth = mcStorage.width / mcStorage.scaleX;
         this.Update();
      }
      
      private function SetupSection(param1:InfernoTransferMonster_CLIP, param2:int) : void
      {
         var section:InfernoTransferMonster_CLIP = param1;
         var index:int = param2;
         this._monsterUi[index] = section;
         section.bRemove.SetupKey("ascdlg_unqueue_btn");
         section.bRemove.addEventListener(MouseEvent.CLICK,function():void
         {
            UnqueueMonster(_monsterUiIds[index]);
         });
         section.bAdd.SetupKey("ascdlg_queue_btn");
         section.bAdd.addEventListener(MouseEvent.CLICK,function():void
         {
            QueueMonster(_monsterUiIds[index]);
         });
      }
      
      public function Update() : void
      {
         var storedRatio:Number;
         var queuedRatio:Number;
         var id:String = null;
         var total:SecNum = null;
         var monsterSize:int = 0;
         var queued:int = 0;
         var index:int = 0;
         var monsterOrder:Array = [];
         this._newHousingUsed.Set(HOUSING._housingUsed.Get());
         for(id in INFERNOPORTAL._ascensionData)
         {
            total = INFERNOPORTAL._ascensionData[id];
            if(total.Get() > 0)
            {
               monsterSize = CREATURES.GetProperty(id,"cStorage",0,true);
               queued = !!this._queuedForAscension[id] ? int(this._queuedForAscension[id].Get()) : 0;
               this._newHousingUsed.Add(queued * monsterSize);
               monsterOrder.push(id);
            }
         }
         monsterOrder.sort(function(param1:String, param2:String):int
         {
            return int(param1.substring(2)) - int(param2.substring(2));
         });
         index = 0;
         while(index < this.NUM_MONSTER_ENTRIES && index < monsterOrder.length)
         {
            id = String(monsterOrder[index]);
            queued = !!this._queuedForAscension[id] ? int(this._queuedForAscension[id].Get()) : 0;
            total = INFERNOPORTAL._ascensionData[id];
            if(this._monsterUiIds[index] != id)
            {
               this._monsterUi[index].tName.text = KEYS.Get(CREATURELOCKER._creatures[id].name);
               this._monsterUiIds[index] = id;
               ImageCache.GetImageWithCallBack("monsters/" + id + "-medium.jpg",this.IconLoaded,true,1,"",[this._monsterUi[index].mcIcon]);
            }
            monsterSize = CREATURES.GetProperty(id,"cStorage",0,true);
            this._monsterUi[index].visible = true;
            this._monsterUi[index].tAvailable.text = KEYS.Get("ascdlg_monsters_available",{
               "v1":queued,
               "v2":total.Get()
            });
            this._monsterUi[index].tAvailable.text = queued + " / " + total.Get();
            this._monsterUi[index].bAdd.Enabled = queued < total.Get() && this._newHousingUsed.Get() + monsterSize <= HOUSING._housingCapacity.Get();
            this._monsterUi[index].bRemove.Enabled = queued > 0;
            index++;
         }
         while(index < this.NUM_MONSTER_ENTRIES)
         {
            this._monsterUi[index].visible = false;
            index++;
         }
         storedRatio = HOUSING._housingUsed.Get() / HOUSING._housingCapacity.Get();
         queuedRatio = this._newHousingUsed.Get() / HOUSING._housingCapacity.Get();
         mcStorage.mcBar.width = this._storageWidth * storedRatio;
         mcStorage.mcBarB.x = this._storageWidth * storedRatio;
         mcStorage.mcBarB.width = this._storageWidth * (queuedRatio - storedRatio);
         tStorage.htmlText = "<b>" + GLOBAL.FormatNumber(this._newHousingUsed.Get()) + " / " + GLOBAL.FormatNumber(HOUSING._housingCapacity.Get()) + " (" + Math.floor(queuedRatio * 100) + "%)</b>";
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
      }
      
      public function QueueMonster(param1:String) : Boolean
      {
         var _loc2_:int = CREATURES.GetProperty(param1,"cStorage",0,true);
         if(!this._queuedForAscension[param1])
         {
            this._queuedForAscension[param1] = new SecNum(0);
         }
         if(this._newHousingUsed.Get() + _loc2_ > HOUSING._housingCapacity.Get())
         {
            return false;
         }
         if(this._queuedForAscension[param1].Get() < INFERNOPORTAL._ascensionData[param1].Get())
         {
            this._queuedForAscension[param1].Add(1);
            this.Update();
            return true;
         }
         return false;
      }
      
      public function UnqueueMonster(param1:String) : Boolean
      {
         if(!this._queuedForAscension[param1] || this._queuedForAscension[param1].Get() <= 0)
         {
            return false;
         }
         this._queuedForAscension[param1].Add(-1);
         this.Update();
         return true;
      }
      
      public function AscendQueuedMonsters() : void
      {
         var _loc1_:SecNum = null;
         var _loc6_:String = null;
         var _loc2_:int = 1;
         var _loc3_:Number = INFERNOPORTAL.building.x + 100;
         var _loc4_:Number = INFERNOPORTAL.building.y + 100;
         var _loc5_:Point = new Point();
         for(_loc6_ in this._queuedForAscension)
         {
            _loc1_ = this._queuedForAscension[_loc6_];
            while(_loc1_.Get() > 0)
            {
               _loc1_.Add(-1);
               INFERNOPORTAL._ascensionData[_loc6_].Add(-1);
               _loc5_.x = _loc3_ + Math.log(_loc2_) * 16 * Math.cos(_loc2_);
               _loc5_.y = _loc4_ - Math.log(_loc2_) * 16 * Math.sin(Math.log(_loc2_) * 4);
               HOUSING.HousingStore(_loc6_,_loc5_);
               _loc2_++;
            }
         }
         INFERNOPORTAL.PageAscensionData();
         this.Hide();
      }
      
      public function Hide() : void
      {
         INFERNOPORTAL.HideAscendMonstersDialog();
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
