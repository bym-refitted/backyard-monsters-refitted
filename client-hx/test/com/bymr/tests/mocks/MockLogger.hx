package com.bymr.tests.mocks;

import com.bymr.hx.api.ILogger;

/**
 * This is a mock implementation of the ILogger interface for testing purposes. 
 * It allows us to simulate the behavior of the LOGGER class in AS3 when running our Haxe tests.
 */
class MockLogger implements ILogger {
	public function new() {
		// Constructor can be empty for this mock
	}

	public function Log(level:String, message:String, param3:Bool = false) {
		trace("[" + level.toUpperCase() + "] " + message);
	}
}
