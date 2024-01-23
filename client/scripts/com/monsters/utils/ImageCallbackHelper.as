package com.monsters.utils
{
    public final class ImageCallbackHelper
    {

        private var _ref:Function;

        private var _state:String;

        private var _level:int;

        private var _imageDataA:Object;

        private var _imageDataB:Object;

        public function ImageCallbackHelper(ref:Function, state:String, level:int, imageDataA:Object, imageDataB:Object)
        {
            super();
            this._ref = ref;
            this._state = state;
            this._level = level;
            this._imageDataA = imageDataA;
            this._imageDataB = imageDataB;
        }

        public function get ref():Function
        {
            return this._ref;
        }

        public function get state():String
        {
            return this._state;
        }

        public function get level():int
        {
            return this._level;
        }

        public function get imageDataA():Object
        {
            return this._imageDataA;
        }

        public function get imageDataB():Object
        {
            return this._imageDataB;
        }

        public function clear():void
        {
            this._ref = null;
            this._state = null;
            this._imageDataA = null;
            this._imageDataB = null;
        }
    }
}