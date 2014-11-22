package hext.io;

import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.MathTools;
import hext.io.Bit;
import hext.io.BitsIterator;
import hext.ds.IndexOutOfBoundsException;

using hext.ArrayTools;

/**
 * TODO
 *
 * Use cases:
 *   - Storing multiple flag member variables. Instead of having 8x a Bool (1 Byte in general)
 *     == 8 Bytes one can use Bit fields == 1 Byte.
 *   - Working on systems with few memory...
 *   - Implementing a new number type
 */
@:forward(length)
abstract Bits(Bytes) from Bytes to Bytes
// implements implements IArrayable implements IStringable
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
     * Note: The returned Bits are always of the same length as 'this'.
     *
     * @param Null<hext.io.Bits> b the Bits to and with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A & B) public function and(b:Null<Bits>):Bits
    {
        var anded:Bytes = Bytes.alloc(this.length);
        if (b != null) {
            var diff:Int = (this.length > b.length) ? (this.length - b.length) : (b.length - this.length);
            var max:Int  = (this.length > b.length) ? this.length : b.length;
            var same:Int = max - diff;
            for (i in 0...same) {
                anded.set(i, this.get(i) & (b:Bytes).get(i));
            }
            anded.blit(same, this, same, diff);
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
    public function copy():Bits
    {
        var copy:Bytes = Bits.alloc(this.length << 3);
        copy.blit(0, this, 0, this.length);

        return copy;
    }

    /**
     * Operator method that is called when two Bits instances are checked for equality.
     *
     * @param Null<hext.io.Bits> b the Bits to check against
     *
     * @return Bool
     */
    @:commutative
    @:op(A == B) public function equals(b:Null<Bits>):Bool
    {
        var equal:Bool = false;
        if (this == null && b == null) {
            equal = true;
        } else if (this == null || b == null) {
            equal = false;
        } else if (this.length == b.length) {
            var i:Int = 0;
            while (i < this.length && this.get(i) == (b:Bytes).get(i)) {
                ++i;
            }
            equal = i == this.length;
        }

        return equal;
    }

    /**
     * Flips the Bit at index 'index'.
     *
     * @param Int index the index of the Bit to flip
     *
     * @return hext.io.Bit the new value of the Bit
     *
     * @throws hext.IllegalArgumentException  if the index is negative
     * @throws hext.IndexOutOfBoundsException if the index is larger than the number of stored bits
     */
    public function flip(index:Int):Bit
    {
        (this:Bits)[index] = ~(this:Bits)[index];
        return (this:Bits)[index];
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
        times            %= this.length << 3;
        var ntimes:Int    = times >>> 3; // how many bytes to shift
        var shift:Int     = times % 8;   // how many bits to shift per byte
        var mask:Int      = (MathTools.MIN_INT32 >> 24) >>> shift; // mask to access shifted out bits
        var shifted:Bytes;
        if (shift == 0 && ntimes == 0) {
            shifted = (this:Bits).copy();
        } else {
            shifted = Bytes.alloc(this.length);
            if (shift == 0) {
                shifted.blit(0, this, 0, this.length);
            } else {
                // shift within the bytes
                var i:Int = this.length - ntimes - 1;
                while (i != 0) {
                    shifted.set(i, (this.get(i) << shift) | ((this.get(i - 1) & mask) >>> (8 - shift)));
                    --i;
                }
                shifted.set(0, this.get(0) << shift);
            }
            // move byte to byte
            shifted.blit(ntimes, shifted, 0, this.length - ntimes);
            for (j in 0...ntimes) {
                shifted.set(j, 0);
            }
        }

        return shifted;

        // not so fast...
        // var nbits:Int    = this.length << 3;
        // var shifted:Bits = (this:Bits).copy();
        // var shift:Int    = times % nbits;
        // if (shift != 0) {
        //     var index:Int  = 0;
        //     var target:Int = index + shift;
        //     while (target < nbits) {
        //         shifted[target] = (this:Bits)[index];
        //         ++index;
        //         target = index + shift;
        //     }
        //     for (i in 0...shift) {
        //         shifted[i] = (0:Bit);
        //     }
        // }

        // return shifted;
    }

    /**
     * Operator method that is called when negating the Bits.
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(~A) public function neg():Bits
    {
        var negd:Bytes = Bytes.alloc(this.length);
        for (i in 0...this.length) {
            negd.set(i, ~this.get(i));
        }

        return negd;
    }

    /**
     * Operator method that is called when two Bits instances are checked for not equality.
     *
     * @param Null<hext.io.Bits> b the Bits to check against
     *
     * @return Bool
     */
    @:commutative
    @:op(A != B) public function nequals(b:Null<Bits>):Bool
    {
        return !(this:Bits).equals(b);
    }

    /**
     * Operator method that is called when oring two Bits instances.
     *
     * Note: The returned Bits are always of the same length as 'this'.
     *
     * @param Null<hext.io.Bits> b the Bits to or with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A | B) public function or(b:Null<Bits>):Bits
    {
        var ored:Bytes;
        if (b == null) {
            ored = (this:Bits).copy();
        } else {
            ored         = Bytes.alloc(this.length);
            var diff:Int = (this.length > b.length) ? (this.length - b.length) : (b.length - this.length);
            var max:Int  = (this.length > b.length) ? this.length : b.length;
            var same:Int = max - diff;
            for (i in 0...same) {
                ored.set(i, this.get(i) | (b:Bytes).get(i));
            }
            ored.blit(same, this, same, diff);
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
        times            %= this.length << 3;
        var ntimes:Int    = times >>> 3;      // how many bytes to shift
        var shift:Int     = times % 8;        // how many bits to shift per byte
        var mask:Int      = (1 << shift) - 1; // mask to access shifted out bits
        var shifted:Bytes;
        if (shift == 0 && ntimes == 0) {
            shifted = (this:Bits).copy();
        } else {
            var length:Int = this.length - 1;
            shifted        = Bytes.alloc(this.length);
            // shift within the bytes
            var i:Int = ntimes;
            while (i < length) {
                shifted.set(i, (this.get(i) >>> shift) | ((this.get(i + 1) & mask) << (8 - shift)));
                ++i;
            }
            shifted.set(length, (this.get(length) << 24) >> (24 + shift));
            // move byte to byte
            shifted.blit(0, shifted, ntimes, this.length - ntimes);
            var mask:Int = if ((this.get(length) >>> 7) == 0) {
                mask = 0;
            } else {
                mask = 0xFF;
            }
            for (j in 0...ntimes) {
                shifted.set(length - j, mask);
            }
        }

        return shifted;

        // not so fast...
        // var nbits:Int    = this.length << 3;
        // var shifted:Bits = (this:Bits).copy();
        // var shift:Int    = times % nbits;
        // if (shift != 0) {
        //     var index:Int  = nbits - 1;
        //     var target:Int = index - shift;
        //     while (target >= 0) {
        //         shifted[target] = (this:Bits)[index];
        //         --index;
        //         target = index - shift;
        //     }
        //     var msb:Bit = shifted[nbits - 1];
        //     for (i in (nbits - shift)...nbits) {
        //         shifted[i] = msb;
        //     }
        // }

        // return shifted;
    }

    /**
     * @{inherit}
     */
    public function toArray():Array<Bit>
    {
        var arr:Array<Bit> = new Array<Bit>();
        for (bit in (this:Bits)) {
            arr.add(bit);
        }

        return arr;
    }

    /**
     * @{inherit}
     *
     * @param Bool group either to add a space after each byte or not
     */
    public function toHex(group:Bool = true):String
    {
        var buf:StringBuf = new StringBuf();
        for (i in 0...this.length) {
            var byte:Int = this.get(this.length - i - 1);
            buf.add(std.StringTools.hex(byte >>> 4));
            buf.add(std.StringTools.hex(byte & 0x0F));
            if (group) {
                buf.add(' ');
            }
        }

        return buf.toString();
    }

    /**
     * TODO
     */
    public function toOctal(group:Bool = true):String
    {
        return "";
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
        times            %= this.length << 3;
        var ntimes:Int    = times >>> 3;      // how many bytes to shift
        var shift:Int     = times % 8;        // how many bits to shift per byte
        var mask:Int      = (1 << shift) - 1; // mask to access shifted out bits
        var shifted:Bytes;
        if (shift == 0 && ntimes == 0) {
            shifted = (this:Bits).copy();
        } else {
            var length:Int = this.length - 1;
            shifted        = Bytes.alloc(this.length);
            if (shift == 0) {
                shifted.blit(0, this, 0, this.length);
            } else {
                // shift within the bytes
                var i:Int = ntimes;
                while (i < length) {
                    shifted.set(i, (this.get(i) >>> shift) | ((this.get(i + 1) & mask) << (8 - shift)));
                    ++i;
                }
                shifted.set(length, this.get(length) >>> shift);
            }
            // move byte to byte
            shifted.blit(0, shifted, ntimes, this.length - ntimes);
            for (j in this.length - ntimes...this.length) {
                shifted.set(j, 0);
            }
        }

        return shifted;

        // not so fast...
        // var nbits:Int    = this.length << 3;
        // var shifted:Bits = (this:Bits).copy();
        // var shift:Int    = times % nbits;
        // if (shift != 0) {
        //     var index:Int  = nbits - 1;
        //     var target:Int = index - shift;
        //     while (target >= 0) {
        //         shifted[target] = (this:Bits)[index];
        //         --index;
        //         target = index - shift;
        //     }
        //     for (i in (nbits - shift)...nbits) {
        //         shifted[i] = (0:Bit);
        //     }
        // }

        // return shifted;
    }

    /**
     * Operator method that is called when xoring two Bits instances.
     *
     * Note: The returned Bits are always of the same length as 'this'.
     *
     * @param Null<hext.io.Bits> b the Bits to xor with
     *
     * @return hext.io.Bits
     */
    @:noCompletion
    @:op(A ^ B) public function xor(b:Null<Bits>):Bits
    {
        var xored:Bytes;
        if (b == null) {
            xored = (this:Bits).copy();
        } else {
            xored        = Bytes.alloc(this.length);
            var diff:Int = (this.length > b.length) ? (this.length - b.length) : (b.length - this.length);
            var max:Int  = (this.length > b.length) ? this.length : b.length;
            var same:Int = max - diff;
            for (i in 0...same) {
                xored.set(i, this.get(i) ^ (b:Bytes).get(i));
            }
            xored.blit(same, this, same, diff);
        }

        return xored;
    }
}
