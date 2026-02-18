package com.cc.utils;

import com.bymr.hx.HaxeLib.GLOBAL;
import com.bymr.hx.HaxeLib.LOGGER;

/**
 * SecNum (Secure Number) - A lightweight obfuscated integer storage class with integrity checking.
 * 
 * This class provides basic anti-tampering protection for numeric values by:
 * 1. XOR-obfuscating the value with a random seed
 * 2. Using bit rotation to create an integrity checksum
 * 
 * **Security Level**: Obfuscation, not cryptography
 * - Designed to deter casual memory editing and basic client-side tampering
 * - NOT secure against determined reverse engineering or cryptanalysis
 * - Provides good balance between security and performance
 * 
 * **Implementation Details**:
 * - Value is XORed with a random 32-bit seed for obfuscation
 * - Checksum is computed by rotating the value (amount based on seed bits)
 * - Rotation amount varies per seed, adding an extra obfuscation layer
 * - Sign is stored separately to support negative values
 * 
 * **Use Cases**:
 * - Storing sensitive game values (currency, resources, scores)
 * - Preventing casual memory scanning/editing tools from finding values
 * - Detecting accidental memory corruption or simple tampering attempts
 * 
 * **Performance**:
 * - All operations are O(1) with minimal overhead
 * - `Get()` performs one XOR decode + one rotation for verification (~2-3 instructions)
 * - `Set()` includes one RNG call plus basic arithmetic
 * - Memory footprint: 3 UInt fields + 1 Bool (~13-16 bytes typically)
 * 
 * **Example**:
 * ```haxe
 * var playerGold = new SecNum(1000);
 * playerGold.Add(500);  // Now contains 1500
 * var currentAmount = playerGold.Get();  // Returns 1500
 * ```
 * 
 * @author tram98
 */
class SecNum {
	/**
	 * Random seed used for XOR obfuscation and rotation-based integrity checking.
	 * Regenerated on every `Set()` call to re-obfuscate the value.
	 */
	private var _seed:UInt;

	/**
	 * Primary obfuscated storage: stores (value XOR seed).
	 * To retrieve the original value, XOR this field with `_seed`.
	 */
	private var _value:UInt;

	/**
	 * Integrity checksum computed via bit rotation.
	 * Stores: rotateLeft(value, seed & 0x1F) XOR (seed >>> 16)
	 * Used to detect tampering during `Get()`.
	 */
	private var _check:UInt;

	/**
	 * Sign flag indicating whether the stored value is negative.
	 * The magnitude is always stored as unsigned; this flag is applied during `Get()`.
	 */
	private var _neg:Bool;

	/**
	 * Constructs a new SecNum instance with the specified initial value.
	 * 
	 * The value is immediately obfuscated with a random seed and stored
	 * with a rotation-based integrity checksum.
	 * 
	 * @param initialValue The integer value to store (can be negative)
	 */
	public function new(initialValue:Int) {
		this.Set(initialValue);
        #if debug
		trace("SecNum initialized with value: " + initialValue);
        #end
	}

	/**
	 * Stores a new value in obfuscated form with a freshly generated random seed.
	 * 
	 * This method performs the following steps:
	 * 1. Extracts and stores the sign, converting to magnitude
	 * 2. Generates a new random 32-bit seed
	 * 3. Obfuscates the magnitude using XOR with the seed
	 * 4. Creates a rotation-based checksum for integrity verification
	 * 
	 * The checksum uses bit rotation (amount determined by seed) combined with
	 * XOR of the high bits of the seed, providing both obfuscation and validation.
	 * 
	 * **Performance**: O(1) with one RNG call and minimal arithmetic
	 * 
	 * @param newValue The new integer value to store (can be negative)
	 */
	public function Set(newValue:Int):Void {
		this._neg = newValue < 0;
		var magnitude:UInt = _neg ? -newValue : newValue;

		this._seed = Std.int(Math.random() * 0xFFFFFFFF);
		this._value = magnitude ^ this._seed;
		this._check = rotateLeft(magnitude, this._seed & 0x1F) ^ (this._seed >>> 16);
	}

	/**
	 * Retrieves the current stored value after deobfuscation and integrity checking.
	 * 
	 * This method performs:
	 * 1. Decodes the value by XORing `_value` with the seed
	 * 2. Recomputes the rotation-based checksum from the decoded value
	 * 3. Compares against the stored `_check` - tampering is detected if they differ
	 * 
	 * If tampering is detected:
	 * - Logs an error message
	 * - Triggers `GLOBAL.ErrorMessage("SecNum")`
	 * - Returns 0 as a safe fallback
	 * 
	 * If integrity check passes:
	 * - Applies the sign flag (`_neg`) to restore negative values
	 * - Returns the original integer value
	 * 
	 * **Performance**: O(1) - one XOR decode, one rotation, one comparison
	 * 
	 * **Security Note**: The rotation-based checksum is fast and effective against
	 * casual tampering but can be reverse-engineered by analyzing the algorithm.
	 * 
	 * @return The deobfuscated integer value, or 0 if integrity check fails
	 */
	public function Get():Int {
		var decoded:UInt = this._value ^ this._seed;
		var verify:UInt = rotateLeft(decoded, this._seed & 0x1F) ^ (this._seed >>> 16);

		if (verify != this._check) {
			LOGGER.Log("err", "SecNum integrity check failed");
			GLOBAL.ErrorMessage("SecNum");
			return 0;
		}

		return this._neg ? -decoded : decoded;
	}

	/**
	 * Adds a value to the currently stored number and returns the result.
	 * 
	 * This is a convenience method that:
	 * 1. Retrieves the current value via `Get()`
	 * 2. Adds the specified amount
	 * 3. Stores the new sum via `Set()` (which regenerates the seed)
	 * 4. Returns the new total
	 * 
	 * **Performance**: O(1), equivalent to one `Get()` + one `Set()`
	 * 
	 * @param numberToAdd The amount to add (can be negative for subtraction)
	 * @return The new total after addition
	 */
	public function Add(numberToAdd:Int):Int {
		var result = numberToAdd + this.Get();
		this.Set(result);
		return result;
	}

	/**
	 * Performs a left bit rotation on a 32-bit unsigned integer.
	 * 
	 * Bit rotation is a circular shift operation where bits shifted off one end
	 * reappear at the other end. This is used for the integrity checksum because:
	 * - It's extremely fast (typically a single CPU instruction)
	 * - It's reversible but non-trivial to predict without knowing the shift amount
	 * - The rotation amount varies per seed, adding obfuscation
	 * 
	 * **Example**: rotateLeft(0b10110001, 3) = 0b10001101
	 * 
	 * @param value The 32-bit value to rotate
	 * @param shift The number of bit positions to rotate left (automatically masked to 0-31)
	 * @return The rotated value
	 */
	private static inline function rotateLeft(value:UInt, shift:Int):UInt {
		shift &= 0x1F; // Ensure shift is 0-31
		return (value << shift) | (value >>> (32 - shift));
	}
}
