package lib.io;

import haxe.Int32;
import haxe.io.Bytes;
import lib.IllegalArgumentException;
import lib.MathTools;
import lib.io.Bit;
import lib.io.BitsIterator;
import lib.ds.IndexOutOfBoundsException;

using lib.StringTools;

/**
 * The Bits abstract can be used to store several true/false flags (Bit)
 * within a single Byte.
 * This should be more memory efficient than storing Bools within an Array.
 *
 * Use cases:
 *   - Storing multiple flag member variables. Instead of having 8x a Bool (1 Byte in general)
 *     == 8 Bytes one can use Bit fields == 1 Byte.
 *   - Working on systems with few memory...
 */
@:forward(fill, get, length, set)
abstract Bits(Bytes) from Bytes to Bytes
{
    /**
     * Constructor to initialize a new Bits instance.
     *
     * @param Int nbits the number of Bit one wants to store
     *
     * @throws lib.IllegalArgumentException if the number of Bit is negative or 0
     */
    public function new(nbits:Int):Void
    {
        if (nbits <= 0) {
            throw new IllegalArgumentException("Cannot allocate a negative (or 0) amount of bits.");
        }

        this = Bytes.alloc(Math.ceil(nbits / 8));
    }

    /**
     * Array access [index] implementation method.
     *
     * @param Int index the index of the Bit to access
     *
     * @return lib.io.Bit
     *
     * @throws lib.IllegalArgumentException  if the index is negative
     * @throws lib.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion @:noUsing
    @:arrayAccess public function array_get(index:Int):Bit
    {
        #if !LIB_PERFORMANCE
            if (index < 0) {
                throw new IllegalArgumentException("Cannot access negative index.");
            }
            if (index >= (this.length << 3)) {
                throw new IndexOutOfBoundsException();
            }
        #end

        var pos:Int    = Math.floor(index / 8);
        var bits:Int   = this.get(pos);
        var offset:Int = index - (pos << 3);

        return (bits & (1 << offset)) != 0;
     }

    /**
     * Array setter [index] implementation method.
     *
     * @param Int        index the index of the Bit to set
     * @param lib.io.Bit value the value to set
     *
     * @throws lib.IllegalArgumentException  if the index is negative
     * @throws lib.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion @:noUsing
    @:arrayAccess public function array_set(index:Int, value:Bit):Void
    {
        #if !LIB_PERFORMANCE
            if (index < 0) {
                throw new IllegalArgumentException("Cannot access negative index.");
            }
            if (index >= (this.length << 3)) {
                throw new IndexOutOfBoundsException();
            }
        #end

        var pos:Int    = Math.floor(index / 8);
        var bits:Int   = this.get(pos);
        var offset:Int = index - (pos << 3);
        if (value) {
            this.set(pos, bits | (1 << offset));
        } else {
            this.set(pos, bits & ~(1 << offset));
        }
    }

    /**
     * Flips the Bit at index 'index'.
     *
     * @param Int index the index of the Bit to flip
     *
     * @return lib.io.Bit
     *
     * @throws lib.IllegalArgumentException  if the index is negative
     * @throws lib.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    public function flip(index:Int):Bit
    {
        #if !LIB_PERFORMANCE
            if (index < 0) {
                throw new IllegalArgumentException("Cannot access negative index.");
            }
            if (index >= (this.length << 3)) {
                throw new IndexOutOfBoundsException();
            }
        #end

        var pos:Int    = Math.floor(index / 8);
        var bits:Int   = this.get(pos);
        var offset:Int = index - (pos << 3);
        var value:Int  = bits ^ (1 << offset);
        this.set(pos, value);

        return value != 0;
    }

    /**
     * Returns an Iterator that can be used in for loops to access each bit, one-by-one.
     *
     * @return lib.io.Bits.BitsIterator
     */
    public function iterator():BitsIterator
    {
        return new BitsIterator(this);
    }

    /**
     * Returns the Bits of the input integer (32bit variant).
     *
     * @param haxe.Int32 i the integer to get the bits for
     *
     * @return lib.io.Bits the integer's Bits
     *
     * @throws lib.IllegalArgumentException if the integer is negative
     */
    public static function ofInt32(i:Int32):Bits
    {
        var bits:Bits = new Bits(32);
        if (i == MathTools.MIN_INT32) {
            bits.flip(31);
        } else {
            var negative:Bool = false;
            if (i < 0) {
                negative = true;
                i = Std.int(Math.abs(i));
            }

            var exp:Int = 0;
            while (Math.pow(2, ++exp) <= i) {}
            var res:Int;
            while (i >= 0 && --exp >= 0) {
                res = Std.int(Math.pow(2, exp)); // (1 << exp) doesn't work e.g. with lib.MathTools.MAX_INT32
                if (i - res >= 0) {
                    bits[exp] = (1:Bit);
                    i -= res;
                }
            }

            if (negative) {
                for (j in 0...4) { // invert bits
                    bits.set(j, ~bits.get(j));
                }
                var j:Int = 0;
                while (bits[j] == (1:Bit)) { // add 1
                    bits[j] = (0:Bit);
                    ++j;
                }
                bits[j] = (1:Bit);
            }
        }

        return bits;
    }

    /**
     * Resets the Bits by setting all of them to 0.
     */
    public inline function reset():Void
    {
        this.fill(0, this.length, 0);
    }

    /**
     * Converts the Bits back to its Int32 value.
     *
     * @param lib.io.Bits bits the Bits to get the Int32 value for
     *
     * @return haxe.Int32
     *
     * @throws lib.IllegalArgumentException if the bits are not from an Int32
     */
    public static function toInt32(bits:Bits):Int32 {
        if (bits == null || bits.length != 4) {
            throw new IllegalArgumentException();
        }

        var i:Int32 = 0;
        for (j in 0...32) {
            if (bits[j] == (1:Bit)) {
                i += 1 << j;
            }
        }

        return i;
    }

    /**
     * @{inherit}
     */
    public function toString():String
    {
        var buf:StringBuf = new StringBuf();
        for (i in 0...32) {
            buf.add(Std.string((this:Bits)[31 - i]));
        }

        return buf.toString();
    }
}
