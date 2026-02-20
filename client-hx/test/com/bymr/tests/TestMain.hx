package com.bymr.tests;

import com.bymr.tests.mocks.MockGlobal;
import com.bymr.tests.mocks.MockLogger;
import com.bymr.hxbridge.HaxeLib;
import com.cc.utils.SecNum;

class TestMain {
	public static function main() {
		trace("Hello from TestMain!");

		HaxeLib.bootstrap(new MockGlobal(), new MockLogger());

		final runs = 9999999;
		var s:SecNum = new SecNum(0);
		for (i in 0...runs) {
			s.Set(i);
			if (s.Get() != i) {
				trace("SecNum broke at " + i);
			}
			s.Set(i * 2);
			if (s.Get() != i * 2) {
				trace("SecNum broke at " + (i * 2));
			}
			if (i % 1000000 == 0) {
				trace("SecNum test progress: " + i + " / " + runs);
			}
		}
		trace("SecNum test completed!");
	}
}
