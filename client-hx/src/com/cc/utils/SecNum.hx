package com.cc.utils;

import com.bymr.hx.HaxeLib.GLOBAL;
import com.bymr.hx.HaxeLib.LOGGER;

class SecNum {
	private static final TWOPOW32:UInt = Std.int(Math.pow(2, 32));

	private var _seed:UInt;

	private var _x:UInt;

	private var _n:UInt;

	private var _n64:UInt;

	private var _neg:Bool;

	public function new(initialValue:Int) {
        this.Set(initialValue);
        trace("SecNum initialized with value: " + initialValue);
	}

	public function Set(newValue:Int):Void {
		this._neg = false;
		if (newValue < 0) {
			newValue *= -1;
			this._neg = true;
		}
		this._seed = Std.int(Math.random() * 99999);
		
        // newValue = Math.round(newValue);
		
        this._x = newValue ^ this._seed;
		this._n = Std.int(newValue) + (this._seed << 1) ^ this._seed;
		this._n64 = Std.int(newValue / TWOPOW32);
	}

	public function Add(numberToAdd:Int):Int {
		this.Set(numberToAdd = numberToAdd + this.Get());
		return numberToAdd;
	}

	public function Get():Int {
		var decodedNumber:UInt = this._n64 * TWOPOW32 + Std.int(this._x ^ this._seed);
		if (decodedNumber == this._n64 * TWOPOW32 + Std.int(Std.int(this._n ^ this._seed) - (this._seed << 1))) {
			if (this._neg) {
				decodedNumber *= -1;
			}
			return decodedNumber;
		}
		LOGGER.Log("err",
			"SecNum Broke (impossible unless.....)"
			+ decodedNumber
			+ " != "
			+ (this._n64 * TWOPOW32 + Std.int(Std.int(this._n ^ this._seed) - (this._seed << 1)))
			+ "?");
		GLOBAL.ErrorMessage("SecNum");
		return 0;
	}
}
