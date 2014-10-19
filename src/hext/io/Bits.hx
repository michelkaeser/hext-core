package hext.io;

import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.io.Bit;
import hext.io.BitsIterator;
import hext.ds.IndexOutOfBoundsException;

using hext.StringTools;

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
@:forward(length, toHex)
abstract Bits(Bytes) from Bytes to Bytes
{
    /**
     * Constructor to initialize a new Bits instance.
     *
     * @param Int nbits the number of Bit one wants to store
     *
     * @throws hext.IllegalArgumentException if the number of Bit is negative or 0
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
     * @return hext.io.Bit
     *
     * @throws hext.IllegalArgumentException  if the index is negative
     * @throws hext.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion
    @:arrayAccess public function array_get(index:Int):Bit
    {
        #if !HEXT_PERFORMANCE
            if (index < 0) {
                throw new IllegalArgumentException("Cannot access negative index.");
            }
            if (index >= (this.length << 3)) {
                throw new IndexOutOfBoundsException();
            }
        #end

        var pos:Int    = Math.floor(index / 8);
        var bits:Int   = (this:Bytes).get(pos);
        var offset:Int = index - (pos << 3);

        return (bits & (1 << offset)) != 0;
     }

    /**
     * Array setter [index] implementation method.
     *
     * @param Int         index the index of the Bit to set
     * @param hext.io.Bit value the value to set
     *
     * @throws hext.IllegalArgumentException  if the index is negative
     * @throws hext.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    @:noCompletion
    @:arrayAccess public function array_set(index:Int, value:Bit):Void
    {
        #if !HEXT_PERFORMANCE
            if (index < 0) {
                throw new IllegalArgumentException("Cannot access negative index.");
            }
            if (index >= (this.length << 3)) {
                throw new IndexOutOfBoundsException();
            }
        #end

        var pos:Int    = Math.floor(index / 8);
        var bits:Int   = (this:Bytes).get(pos);
        var offset:Int = index - (pos << 3);
        if (value) {
            (this:Bytes).set(pos, bits | (1 << offset));
        } else {
            (this:Bytes).set(pos, bits & ~(1 << offset));
        }
    }

    /**
     * Flips the Bit at index 'index'.
     *
     * @param Int index the index of the Bit to flip
     *
     * @return hext.io.Bit
     *
     * @throws hext.IllegalArgumentException  if the index is negative
     * @throws hext.IndexOutOfBoundsException if the index is larger than the number of stored bits
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
        var bits:Int   = (this:Bytes).get(pos);
        var offset:Int = index - (pos << 3);
        var value:Int  = bits ^ (1 << offset);
        (this:Bytes).set(pos, value);

        return value != 0;
    }

    /**
     * Returns an Iterator that can be used in for loops to access each bit, one-by-one.
     *
     * @return hext.io.Bits.BitsIterator
     */
    public function iterator():BitsIterator
    {
        return new BitsIterator(this);
    }

    /**
     * Resets the Bits by setting all of them to 0.
     */
    public function reset():Void
    {
        (this:Bytes).fill(0, this.length, 0);
    }

    /**
     * @{inherit}
     */
    public function toString(#if (js || php) group:Int = 8 #end):String
    {
        var buf:StringBuf = new StringBuf();
        var nbits:Int     = (this.length << 3);
        for (i in 0...nbits) {
            #if (js || php)
                if (i % group == 0 && i != 0) {
                    buf.add(' ');
                }
            #end
            buf.add(Std.string((this:Bits)[nbits - i - 1]));
        }

        return buf.toString();
    }
}
