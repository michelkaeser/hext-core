package hext.io;

import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.MathTools;
import hext.io.Bit;
import hext.io.BitsIterator;
import hext.ds.IndexOutOfBoundsException;

using hext.StringTools;

/**
 * TODO
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
     * Operator method that is called when anding two Bits instances.
     *
     * @param hext.io.Bits b the Bits to and with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A & B) public function and(b:Bits):Bits
    {
        var anded:Bytes = (this:Bits).clone();
        for (i in 0...(this.length > b.length ? this.length : b.length)) {
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
     * Returns a copy of the current instance.
     *
     * @return hext.io.Bits
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
    public inline function iterator():BitsIterator
    {
        return new BitsIterator(this);
    }

    /**
     * Operator method that is called when left shifting the Bits.
     *
     * @param Int times the number of times to shift
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A << B) public function lshift(times:Int):Bits
    {
        var nbits:Int    = this.length << 3;
        var shifted:Bits = (this:Bits).clone();
        var shift:Int    = times % nbits;
        if (shift != 0) {
            var index:Int  = nbits - 1;
            var source:Int = index - shift;
            while (source >= 0) {
                shifted[index] = shifted[source];
                --index;
                source = index - shift;
            }
            for (i in 0...shift) {
                shifted[i] = (0:Bit);
            }
        }

        return shifted;
    }

    /**
     * Operator method that is called when negating the Bits.
     *
     * @return hext.io.Bits
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
     * Operator method that is called when oring two Bits instances.
     *
     * @param hext.io.Bits b the Bits to or with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A | B) public function or(b:Bits):Bits
    {
        var ored:Bytes = (this:Bits).clone();
        for (i in 0...(this.length > b.length ? this.length : b.length)) {
            ored.set(i, this.get(i) | (b:Bytes).get(i));
        }

        return ored;
    }

    /**
     * Resets the Bits by setting all of them to 0.
     */
    public inline function reset():Void
    {
        this.fill(0, this.length, 0);
    }

    /**
     * Operator method that is called when right shifting the Bits.
     *
     * @param Int times the number of times to shift
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A >> B) public function rshift(times:Int):Bits
    {
        var nbits:Int    = this.length << 3;
        var shifted:Bits = (this:Bits).clone();
        var shift:Int    = times % nbits;
        if (shift != 0) {
            var index:Int  = 0;
            var source:Int = index + shift;
            while (source < nbits) {
                shifted[index] = shifted[source];
                ++index;
                source = index + shift;
            }
            var msb:Bit = shifted[nbits - 1];
            for (i in (nbits - shift)...nbits) {
                shifted[i] = msb;
            }
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
     * Operator method that is called when right shifting (unsigned) the Bits.
     *
     * @param Int times the number of times to shift
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A >>> B) public function urshift(times:Int):Bits
    {
        var nbits:Int    = this.length << 3;
        var shifted:Bits = (this:Bits).clone();
        var shift:Int    = times % nbits;
        if (shift != 0) {
            var index:Int  = 0;
            var source:Int = index + shift;
            while (source < nbits) {
                shifted[index] = shifted[source];
                ++index;
                source = index + shift;
            }
            for (i in (nbits - shift)...nbits) {
                shifted[i] = (0:Bit);
            }
        }

        return shifted;
    }

    /**
     * Operator method that is called when xoring two Bits instances.
     *
     * @param hext.io.Bits b the Bits to xor with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A ^ B) public function xor(b:Bits):Bits
    {
        var xored:Bytes = (this:Bits).clone();
        for (i in 0...(this.length > b.length ? this.length : b.length)) {
            xored.set(i, this.get(i) ^ (b:Bytes).get(i));
        }

        return xored;
    }
}
