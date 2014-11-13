package hext.io;

import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.io.Bit;
import hext.io.BitsIterator;
import hext.ds.IndexOutOfBoundsException;

using hext.StringTools;

/**
 * The Bits abstract can be used to store several true/false flags (Bit) within a single Byte.
 * This should be more memory efficient than storing Bools within an Array.
 *
 * Use cases:
 *   - Storing multiple flag member variables. Instead of having 8x a Bool (1 Byte in general)
 *     == 8 Bytes one can use Bit fields == 1 Byte.
 *   - Working on systems with few memory...
 *   - Implementing a new number type (like Int128)
 */
@:forward(length, toHex)
abstract Bits(Bytes) from Bytes to Bytes
// implements ICloneable
{
    /**
     * Constructor to initialize a new Bits instance.
     *
     * @param haxe.io.Bytes bytes the underlaying Bytes to use
     */
    private inline function new(bytes:Bytes):Void
    {
        this = bytes;
    }

    /**
     * Allocates the given number of Bits.
     *
     * @param Int nbits the number of Bits to allocate
     *
     * @throws hext.IllegalArgumentException if the number of Bits is negative or 0
     */
    public static function alloc(nbits:Int):Bits
    {
        if (nbits <= 0) {
            throw new IllegalArgumentException("Cannot allocate a negative (or 0) amount of bits.");
        }

        return new Bits(Bytes.alloc(Math.ceil(nbits / 8)));
    }

    /**
     *
     */
    @:noCompletion
    @:op(A & B) public function and(b:Bits):Bits
    {
        var length:Int  = this.length > b.length ? this.length : b.length;
        var anded:Bytes = (this:Bits).clone();
        for (i in 0...length) {
            anded.set(i, this.get(i) & (b:Bytes).get(i));
        }

        return anded;
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
        var bits:Int   = this.get(pos);
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
        var bits:Int   = this.get(pos);
        var offset:Int = index - (pos << 3);
        if (value) {
            this.set(pos, bits | (1 << offset));
        } else {
            this.set(pos, bits & ~(1 << offset));
        }
    }

    /**
     *
     */
    public function clone():Bits
    {
        var copy:Bytes = Bits.alloc(this.length << 3);
        copy.blit(0, this, 0, this.length);

        return copy;
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
        var bits:Int   = this.get(pos);
        var offset:Int = index - (pos << 3);
        var value:Int  = bits ^ (1 << offset);
        this.set(pos, value);

        return value != 0;
    }

    /**
     * Returns an Iterator that can be used in for loops to access each bit, one-by-one.
     *
     * @return hext.io.BitsIterator
     */
    public function iterator():BitsIterator
    {
        return new BitsIterator(this);
    }

    @:noCompletion
    @:op(A << B) public function lshift(times:Int):Bits
    {
        var nbits:Int     = this.length << 3;
        var shifted:Bytes = Bits.alloc(nbits);
        var carry:UInt    = 0;
        for (i in 0...this.length) {
            var byte:Int       = this.get(i);
            var byteShift:Int  = times % nbits;
            var carryShift:Int = (times - (i << 3)); // apply carry to correct byte (e.g << 16 -> 2)
            if (carryShift > 0) {
                shifted.set(i, (byte << byteShift) | (carry << carryShift));
            } else {
                shifted.set(i, (byte << byteShift) | (carry >> -carryShift));
            }

            var offset:Int = times >= 8 ? 8 : times;
            carry |= byte & ((1 << 31) >> (23 + offset)); // bits that were shifted out
        }

        return shifted;
    }

    /**
     *
     */
    @:noCompletion
    @:op(~A) public function neg():Bits
    {
        var negd:Bytes = (this:Bits).clone();
        for (i in 0...this.length) {
            negd.set(i, ~this.get(i));
        }

        return negd;
    }

    /**
     *
     */
    @:noCompletion
    @:op(A | B) public function or(b:Bits):Bits
    {
        var length:Int = this.length > b.length ? this.length : b.length;
        var ored:Bytes = (this:Bits).clone();
        for (i in 0...length) {
            ored.set(i, this.get(i) | (b:Bytes).get(i));
        }

        return ored;
    }

    /**
     * Resets the Bits by setting all of them to 0.
     */
    public function reset():Void
    {
        this.fill(0, this.length, 0);
    }

    @:noCompletion
    @:op(A >> B) public function rshift(times:Int):Bits
    {
        var shifted:Bytes = Bits.alloc(this.length << 3);
        var carry:Int     = 0;
        for (i in 0...this.length) {
            var index:Int = this.length - i - 1;
            var byte:Int  = this.get(index);
            if (i == 0) {
                shifted.set(index, ((byte << 24) >> 24) >> times);
            } else {
                shifted.set(index, (byte >>> times) | (carry << (8 - times)));
            }
            carry = byte & ((2 << (times - 1)) - 1);
            trace(carry);
        }

        return shifted;
    }

    /**
     * @{inherit}
     */
    public function toString(#if (js || php) group:Int = 8 #end):String
    {
        var buf:StringBuf = new StringBuf();
        var nbits:Int     = this.length << 3;
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

    /**
     *
     */
    @:noCompletion
    @:op(A ^ B) public function xor(b:Bits):Bits
    {
        var length:Int  = this.length > b.length ? this.length : b.length;
        var xored:Bytes = (this:Bits).clone();
        for (i in 0...length) {
            xored.set(i, this.get(i) ^ (b:Bytes).get(i));
        }

        return xored;
    }
}
