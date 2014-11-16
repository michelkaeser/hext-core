package hext;

import haxe.Int32;
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
    private inline function new(b:Bits):Void
    {
        this = { bits: b };
    }

    public function bitss():Bits
    {
        return untyped this.bits;
    }

    /**
     *
     */
    public static function alloc():Int128
    {
        return new Int128(Bits.alloc(128));
    }

    /**
     *
     */
    @:noCompletion
    @:op(A + B) public function add(i:Int128):Int128
    {
        var x:Bits    = this.bits.copy();
        var y:Bits    = untyped i.bits;
        var carry:Bit = (0:Bit);

        for (i in 0...128) {
            var z:Bit = x[i];
            x[i]      = (z ^ y[i]) ^ carry;
            carry     = (carry & x[i]) | (z & y[i]);

            /*if (x[i] | y[i]) {
                if (x[i] && y[i]) {
                    x[i] = (0:Bit);
                    var j:Int = i + 1;
                    while (x[j] == (1:Bit) && j < 127) {
                        x[j] = (0:Bit);
                        ++j;
                    }
                    x[j] = (1:Bit);
                } else {
                    x[i] = (1:Bit);
                }
            }*/
        }
        return new Int128(x);
    }

    @:noCompletion
    @:op(A / B) public function div(i:Int128):Int128
    {
        return cast this;
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
    @:noCompletion
    @:op(A << B) public function lshift(times:Int):Int128
    {
        return new Int128(this.bits.copy() << times);
    }

    @:noCompletion
    @:op(A % B) public function mod(i:Int128):Int128
    {
        return cast this;
    }

    /**
     *
     */
    @:noCompletion
    @:op(A >> B) public function rshift(times:Int):Int128
    {
        return new Int128(this.bits.copy() >> times);
    }

    @:noCompletion
    @:op(A - B) public function subs(i:Int128):Int128
    {
        return cast this;
    }

    @:noCompletion
    @:op(A * B) public function times(i:Int128):Int128
    {
        return cast this;
    }

    /**
     *
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
     *
     */
    @:noCompletion
    @:op(A >>> B) public function urshift(times:Int):Int128
    {
        return new Int128(this.bits.copy() >>> times);
    }
}
