package lib.ds;

import haxe.io.Bytes;
import lib.Bit;
import lib.IllegalArgumentException;
import lib.ds.IndexOutOfBoundsException;

using lib.StringTools;

/**
 * The Bits abstract can be used to store several true/false flags (Bit)
 * within a single Byte.
 * This should be more memory efficient than storing Bools within an Array.
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
     * @return lib.Bit
     *
     * @throws lib.IllegalArgumentException  if the index is negative
     * @throws lib.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion @:noUsing
    @:arrayAccess public function array_get(index:Int):Bit
    {
        if (index < 0) {
            throw new IllegalArgumentException("Cannot access negative index.");
        }
        if (index >= (this.length << 3)) {
            throw new IndexOutOfBoundsException();
        }

        var bits:Int = this.get(Math.floor(index / 8));
        return (bits & (1 << index)) != 0;
     }

    /**
     * Array setter [index] implementation method.
     *
     * @param Int     index the index of the Bit to set
     * @param lib.Bit value the value to set
     *
     * @throws lib.IllegalArgumentException  if the index is negative
     * @throws lib.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion @:noUsing
    @:arrayAccess public function array_set(index:Int, value:Bit):Void
    {
        if (index < 0) {
            throw new IllegalArgumentException("Cannot access negative index.");
        }
        if (index >= (this.length << 3)) {
            throw new IndexOutOfBoundsException();
        }

        var pos:Int  = Math.floor(index / 8);
        var bits:Int = this.get(pos);
        if (value) {
            this.set(pos, bits | (1 << index));
        } else {
            this.set(pos, bits & ~(1 << index));
        }
    }

    /**
     * Returns an Iterator that can be used in for loops to access each bit, one-by-one.
     *
     * @return lib.Bits.BitsIterator
     */
    public function iterator():BitsIterator
    {
        return new BitsIterator(this);
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
     * @var lib.Bits
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
     * @param lib.Bits bits the Bits to iterate over
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
     * @return lib.Bit
     */
    public inline function next():Bit
    {
        return this.bits[this.position++];
    }
 }

