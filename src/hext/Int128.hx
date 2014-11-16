package hext;

import haxe.Int32;
import haxe.Int64;
import haxe.io.Bytes;
import hext.io.Bit;
import hext.io.Bits;

/**
 *
 */
abstract Int128({ bits:Bits })
{
    /**
     *
     */
    private static inline var NBITS:Int  = Int128.NBYTES << 3;
    private static inline var NBYTES:Int = 16;


    /**
     *
     */
    private inline function new(b:Bits):Void
    {
        this = { bits: b };
    }

    /**
     * @{inherit}
     */
    public static function alloc():Int128
    {
        return new Int128(Bits.alloc(Int128.NBITS));
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A & B) public function and(i:Int128):Int128
    {
        return new Int128(this.bits & untyped i.bits);
    }

    /**
     *
     */
    @:noCompletion
    @:op(A + B) public function add(i:Int128):Int128
    {
        var x:Bits    = this.bits;
        var y:Bits    = untyped i.bits;
        var z:Bits    = Bits.alloc(Int128.NBITS);

        var carry:Bit = (0:Bit);
        for (i in 0...Int128.NBITS) {
            z[i]  = (x[i] ^ y[i]) ^ carry;
            carry = (carry & x[i]) | (x[i] & y[i]);
        }

        return new Int128(z);
    }

    @:noCompletion
    @:op(A / B) public function div(i:Int128):Int128
    {
        return cast this;
    }

    /**
     * @{inherit}
     */
    @:op(A == B) public function equals(i:Int128):Bool
    {
        return this.bits == untyped i.bits;
    }

    /**
     *
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt32(i:Int32):Int128
    {
        var i128:Int128 = Int128.alloc();
        for (j in 0...4) {
            untyped (i128.bits:Bytes).set(j, i >> (j * 8));
        }

        return i128;
    }

    /**
     *
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt64(i:Int64):Int128
    {
        var i128:Int128 = Int128.alloc();
        for (j in 0...8) {
            untyped (i128.bits:Bytes).set(j, Int64.toInt(Int64.shr(i, j * 8)));
        }

        return i128;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A << B) public function lshift(times:Int):Int128
    {
        return new Int128(this.bits << times);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(~A) public function neg():Int128
    {
        return new Int128(~this.bits);
    }

    /**
     * @{inherit}
     */
    @:op(A != B) public function nequals(i:Int128):Bool
    {
        return (this.bits != untyped i.bits);
    }

    @:noCompletion
    @:op(A % B) public function mod(i:Int128):Int128
    {
        return cast this;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A | B) public function or(i:Int128):Int128
    {
        return new Int128(this.bits | untyped i.bits);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A >> B) public function rshift(times:Int):Int128
    {
        return new Int128(this.bits >> times);
    }

    @:noCompletion
    @:op(A - B) public function subs(i:Int128):Int128
    {
        return cast this;
    }

    /**
     * TODO: x must be larget y?
     *
     * @link http://en.wikipedia.org/wiki/Bitwise_operation#Applications
     */
    @:noCompletion
    @:op(A * B) public function times(i:Int128):Int128
    {
        var x:Int128 = new Int128(this.bits.copy());
        var y:Int128 = new Int128((untyped i.bits:Bits).copy());
        var z:Int128 = Int128.alloc();

        while (y != 0) {
            if ((y & 1) != 0) {
                z += x;
            }
            x <<= 1;
            y >>= 1;
        }

        return z;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    public function toHex():String
    {
        return this.bits.toHex();
    }

    /**
     *
     * @link http://en.wikipedia.org/wiki/Double_dabble
     * @link http://stackoverflow.com/questions/8023414/how-to-convert-a-128-bit-integer-to-a-decimal-ascii-string-in-c
     * @link http://www.codeobsessed.com/binary-decimal-converters.html
     */
    @:noCompletion
    public function toString():String
    {
        return this.bits.toString();
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A >>> B) public function urshift(times:Int):Int128
    {
        return new Int128(this.bits >>> times);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A ^ B) public function xor(i:Int128):Int128
    {
        return new Int128(this.bits ^ untyped i.bits);
    }
}
