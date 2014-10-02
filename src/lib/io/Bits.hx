package lib.io;

import haxe.Int32;
import haxe.Int64;
import haxe.io.Bytes;
import lib.IllegalArgumentException;
import lib.io.Bit;
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
        if (i < 0) {
            throw new IllegalArgumentException("Negative numbers cannot be converted to binary.");
        }

        var bits:Bits = new Bits(32);
        var exp:Int   = 0;
        while (Math.pow(2, ++exp) <= i) {}
        var res:Int;
        while (i >= 0 && --exp >= 0) {
            res = Std.int(Math.pow(2, exp));
            if (i - res >= 0) {
                bits[exp] = (1:Bit);
                i -= res;
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
     * @{inherit}
     */
    public function toString():String
    {
        var buf:StringBuf = new StringBuf();
        for (bit in (this:Bits)) {
            buf.add(Std.string(bit));
        }

        return buf.toString().reverse();
    }
}


/**
 * Iterator class to traverse each Bit of a Bits abstract.
 *
 * @see http://api.haxe.org/Iterator.html
 */
class BitsIterator
{
    /**
     * Stores the Bits over which we iterate.
     *
     * @var lib.io.Bits
     */
    private var bits:Bits;

    /**
    * Stores current index/position.
    *
    * @var Int
    */
    private var position:Int;


    /**
     * Constructor to initialize a new BitsIterator instance.
     *
     * @param lib.io.Bits bits the Bits to iterate over
     */
    public function new(bits:Bits):Void
    {
        this.bits     = bits;
        this.position = 0;
    }

    /**
     * Checks if there is another bit remaining.
     *
     * @return Bool
     */
    public inline function hasNext():Bool
    {
        return this.position < (this.bits.length << 3);
    }

    /**
     * Returns the next Bit.
     *
     * @return lib.io.Bit
     */
    public inline function next():Bit
    {
        return this.bits[this.position++];
    }
 }

