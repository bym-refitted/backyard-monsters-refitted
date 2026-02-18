package com.bymr.tests.mocks;

import com.bymr.hx.api.IGlobal;

/**
 * This is a mock implementation of the IGlobal interface for testing purposes. 
 * It allows us to simulate the behavior of the GLOBAL class in AS3 when running our Haxe tests.
 */
class MockGlobal implements IGlobal {
	public function new() {
		// Constructor can be empty for this mock
	}

	public function log(message:String):Void {
		trace("[GLOBAL LOG] " + message);
	}

	public function ErrorMessage(message:String = "", errorType:Int = 0):Void {
		trace("[GLOBAL ERROR] " + message + " (Error Type: " + errorType + ")");
		throw "Error occurred: " + message; // Simulate an error by throwing an exception
	}
}
