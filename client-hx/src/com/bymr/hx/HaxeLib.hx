package com.bymr.hx;

import com.bymr.hx.api.IGlobal;

class HaxeLib
{
    private static var _instance:HaxeLib;

    private var _global:IGlobal;

    function new() {}

    /**
     * Bootstraps the haxe library by providing decoupled access to the AS3 code though interfaces. 
     * This allows the Haxe code to call methods on the AS3 code without directly depending on AS3 classes.
     * 
     * @param globalInstance 
     */
    public static function bootstrap(globalInstance: IGlobal):Void {
        if (_instance != null) {
            return;
        }
        _instance = new HaxeLib();
        
        _instance._global = globalInstance;

        HaxeLib.global().log("HaxeLib bootstrapped successfully!");
    }


    /**
     * Returns the instance of the GLOBAL class in AS3, which implements the IGlobal interface.
     * This allows Haxe code to call methods on the GLOBAL class in AS3 through the IGlobal interface.
     * 
     * @return IGlobal instance that allows calling methods on the GLOBAL class in AS3.
     */
    public static function global():IGlobal {
        if (_instance == null) {
            throw "HaxeLib not bootstrapped. Call HaxeLib.bootstrap() first.";
        }
        return _instance._global;
    }
}