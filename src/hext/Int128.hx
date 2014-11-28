package hext;

import haxe.Int32;
import haxe.Int64;
import haxe.io.Bytes;
import hext.UnsupportedOperationException;
import hext.io.Bit;
import hext.io.Bits;

/**
 * An abstract cross-target 128-bit signed Integer implementation.
 *
 * TODO:
 *   - div, mod
 *   - check immutability
 *   - check if bits alone can be used as underlaying type
 *
 * Performance:
 *   - SUPER: ++A, --B
 *   - GOOD:  A + B, A - B, A & B, A == B
 *   - OK:    A << B, A >> B, A >>> B, A | B, A ^ B
 *   - BAD:   A * B, A / B
 */
@:forward(toHex, toOctal)
abstract Int128(Bits)
{
    /**
     * Stores the max value an Int128 can hold.
     *
     * @var hext.Int128
     */
    public static var MAX_VALUE(default, never):Int128 = {
        var i:Int128 = 1;
        i = i.lshift(Int128.NBITS - 1);
        i = i.subs(1);
        i;
    };

    /**
     * Stores the min value an Int128 can hold.
     *
     * @var hext.Int128
     */
    public static var MIN_VALUE(default, never):Int128 = {
        var i:Int128 = 1;
        i = i.lshift(Int128.NBITS - 1);
        i;
    };

    /**
     * Stores the number of Bits the Int128 needs.
     *
     * @var Int
     */
    private static inline var NBITS:Int = Int128.NBYTES << 3;

    /**
     * Stores the number of Bytes the Int128 needs.
     *
     * @var Int
     */
    private static inline var NBYTES:Int = 16;

    /**
     * Stores some commonly used loop condition values.
     *
     * Performance tests showed that (i != 0) is ways slower (~10x) than
     * ((i & 1) != 0), so we have this static values that not every method
     * must init its own vars.
     *
     * @var hext.Int128
     */
    public static var ZERO(default, never):Int128 = Int128.alloc();
    public static var ONE(default, never):Int128  = Int128.fromInt32(1);


    /**
     * Constructor to initialize a new Int128 instance.
     *
     * @var hext.io.Bits b the underlaying Bits to use
     */
    private inline function new(b:Bits):Void
    {
        this = b;
    }

    /**
     * @{inherit}
     */
    public static function alloc():Int128
    {
        return new Int128(Bytes.alloc(Int128.NBYTES));
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:commutative
    @:op(A & B) public function and(i:Int128):Int128
    {
        return new Int128(this & cast i);
    }

    /**
     * Operator method that is called when adding two Int128s.
     *
     * @link https://en.wikipedia.org/wiki/Binary_number#Addition
     *
     * @param hext.Int128 i the Int128 to add
     *
     * @return hext.Int128
     */
    @:noCompletion
    @:commutative
    @:op(A + B) public function add(i:Int128):Int128
    {
        var x:Bytes   = this;
        var y:Bytes   = cast i;
        var z:Bytes   = Bytes.alloc(Int128.NBYTES);
        var carry:Int = 0;
        for (i in 0...Int128.NBYTES) {
            var sum:Int = x.get(i) + y.get(i) + carry;
            z.set(i, sum);
            carry = sum >>> 8;
        }

        return new Int128(z);
    }

    /**
     * Compares the current instance and the Int128 passed as an argument.
     *
     * @link https://en.wikipedia.org/wiki/Two%27s_complement#Comparison_.28ordering.29
     *
     * @param hext.Int128 i the Int128 to compare with
     *
     * @return Int
     */
    private function compareTo(i:Int128):Int
    {
        var x:Bytes = this;
        var y:Bytes = cast i;
        var a:Bit   = (x:Bits)[Int128.NBITS - 1];
        var b:Bit   = (y:Bits)[Int128.NBITS - 1];
        if (~a && b) {
            return 1;
        } else if (a && ~b) {
            return -1;
        } else {
            var i:Int = Int128.NBYTES - 1;
            while (i != -1) {
                var c:Int = x.get(i);
                var d:Int = y.get(i);
                if (c > d) {
                    return 1;
                } else if (c < d) {
                    return -1;
                }
                --i;
            }

            return 0;
        }
    }

    /**
     * Returns a copy of the passed-in Int128.
     *
     * @param hext.Int128 i the Int128 to copy
     *
     * @return hext.Int128
     */
    public static function copy(i:Int128):Int128
    {
        return new Int128((cast i:Bits).copy());
    }

    /**
     * Operator method that is called when dividing an Int128.
     *
     * TODO: negative values (either dividend or divisor)
     *
     * @link http://stackoverflow.com/questions/5284898/implement-division-with-bit-wise-operator
     * @link http://www.wikihow.com/Divide-Binary-Numbers
     *
     * @param hext.Int128 i the divisor
     *
     * @return hext.Int128
     */
    @:noCompletion
    @:op(A / B) public function div(i:Int128):Int128
    {
        if (i == 0) {
            throw new UnsupportedOperationException("Division by zero.");
        }

        var sum:Int128 = Int128.alloc();
        while ((sum.times(i)).lessEquals(cast this)) {
            ++sum;
        }

        return --sum;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:commutative
    @:op(A == B) public function equals(i:Int128):Bool
    {
        return this == cast i;
    }

    /**
     * Type-casting helper method to cast an Int32 to an Int128.
     *
     * @param haxe.Int32 i the Int32 to cast
     *
     * @return hext.Int128
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt32(i:Int32):Int128
    {
        var bits:Bytes = Bytes.alloc(Int128.NBYTES);
        for (j in 0...4) {
            bits.set(j, i >> (j * 8));
        }
        if (0 > i) {
            for (j in 4...Int128.NBYTES) {
                bits.set(j, 0xFF);
            }
        }

        return new Int128(bits);
    }

    /**
     * Type-casting helper method to cast an Int64 to an Int128.
     *
     * @param haxe.Int64 i the Int64 to cast
     *
     * @return hext.Int128
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt64(i:Int64):Int128
    {
        var bits:Bytes = Bytes.alloc(Int128.NBYTES);
        for (j in 0...8) {
            bits.set(j, Int64.toInt(Int64.shr(i, j * 8)));
        }
        if (Int64.isNeg(i)) {
            for (j in 8...Int128.NBYTES) {
                bits.set(j, 0xFF);
            }
        }

        return new Int128(bits);
    }

    /**
     * Operator method that is called when comparing two Int128s for 'greater than'.
     *
     * @param hext.Int128 i the Int128 to check against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A > B) public function greater(i:Int128):Bool
    {
        return i.compareTo(cast this) == -1;
    }

    /**
     * Operator method that is called when checking two Int128s for 'is greater or equal than'.
     *
     * @param hext.Int128 i the Int128 to check against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A >= B) public function greaterEquals(i:Int128):Bool
    {
        return i.compareTo(cast this) != 1;
    }

    /**
     * Checks if the Int128 holds a negative value.
     *
     * @param hext.Int128 i the Int128 to check
     *
     * @return Bool
     */
    public static function isNegative(i:Int128):Bool
    {
        return (cast i:Bits)[Int128.NBITS - 1];
    }

    /**
     * Checks if the Int128 holds a positive value.
     *
     * @param hext.Int128 i the Int128 to check
     *
     * @return Bool
     */
    public static function isPositive(i:Int128):Bool
    {
        return !Int128.isNegative(i);
    }

    /**
     * Operator method that is called when comparing two Int128s for 'less than'.
     *
     * @param hext.Int128 i the Int128 to check against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A < B) public function less(i:Int128):Bool
    {
        return i.compareTo(cast this) == 1;
    }

    /**
     * Operator method that is called when checking two Int128s for 'is less or equal than'.
     *
     * @param hext.Int128 i the Int128 to check against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A <= B) public function lessEquals(i:Int128):Bool
    {
        return i.compareTo(cast this) != -1;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A << B) public function lshift(times:Int):Int128
    {
        return new Int128(this << times);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(~A) public function neg():Int128
    {
        return new Int128(~this);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:commutative
    @:op(A != B) public function nequals(i:Int128):Bool
    {
        return this.nequals(cast i);
    }

    /**
     * Operator method that is called when prefixing an Int128 with the minus sign.
     *
     * @return hext.Int128
     */
    @:noCompletion
    @:op(-A) public function minus():Int128
    {
        return Int128.ZERO.subs(cast this);
    }

    /**
     * TODO: implementation
     */
    @:noCompletion
    @:op(A % B) public function mod(i:Int128):Int128
    {
        return new Int128(this);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:commutative
    @:op(A | B) public function or(i:Int128):Int128
    {
        return new Int128(this | cast i);
    }

    /**
     * Operator method that is called when post-decrementing an Int128.
     *
     * Note: This operator modifies the Int128 in-place.
     *
     * @return hext.Int128 the Int128 before decrementation
     */
    @:noCompletion
    @:op(A--) public function postDec():Int128
    {
        var copy:Bits = this.copy();
        var i:Int     = 0;
        while (i < Int128.NBITS) {
            if (this[i]) {
                this[i] = (0:Bit);
                break;
            } else {
                this[i] = (1:Bit);
            }
            ++i;
        }

        return new Int128(copy);
    }

    /**
     * Operator method that is called when post-incrementing an Int128.
     *
     * Note: This operator modifies the Int128 in-place.
     *
     * @return hext.Int128 the Int128 before incrementation
     */
    @:noCompletion
    @:op(A++) public function postInc():Int128
    {
        var copy:Bits = this.copy();
        var i:Int     = 0;
        while (i < Int128.NBITS) {
            if (this[i]) {
                this[i] = (0:Bit);
            } else {
                this[i] = (1:Bit);
                break;
            }
            ++i;
        }

        return new Int128(copy);
    }

    /**
     * Operator method that is called when pre-decrementing an Int128.
     *
     * Note: This operator modifies the Int128 in-place.
     *
     * @return hext.Int128 the decremented Int128
     */
    @:noCompletion
    @:op(--A) public function preDec():Int128
    {
        var i:Int = 0;
        while (i < Int128.NBITS) {
            if (this[i]) {
                this[i] = (0:Bit);
                break;
            } else {
                this[i] = (1:Bit);
            }
            ++i;
        }

        return cast this;
    }

    /**
     * Operator method that is called when pre-incrementing an Int128.
     *
     * Note: This operator modifies the Int128 in-place.
     *
     * @return hext.Int128 the incremented Int128
     */
    @:noCompletion
    @:op(++A) public function preInc():Int128
    {
        var i:Int = 0;
        while (i < Int128.NBITS) {
            if (this[i]) {
                this[i] = (0:Bit);
            } else {
                this[i] = (1:Bit);
                break;
            }
            ++i;
        }

        return cast this;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A >> B) public function rshift(times:Int):Int128
    {
        return new Int128(this >> times);
    }

    /**
     * Operator method that is called when substracting two Int128s.
     *
     * @link https://en.wikipedia.org/wiki/Binary_number#Subtraction
     * @link http://courses.cs.vt.edu/~cs1104/BuildingBlocks/arithmetic.040.html
     *
     * @param hext.Int128 i the Int128 to substract
     *
     * @return hext.Int128
     */
    @:noCompletion
    @:op(A - B) public function subs(i:Int128):Int128
    {
        var subs:Int128 = new Int128(~(cast i:Bits));
        return ++subs.add(cast this);
    }

    /**
     * Operator method that is called when mutliplication two Int128s.
     *
     * @link http://en.wikipedia.org/wiki/Bitwise_operation#Applications
     *
     * @param hext.Int128 i the value to multiplicate with
     *
     * @return hext.Int128 the sum of the multiplication
     */
    @:noCompletion
    @:op(A * B) public function times(i:Int128):Int128
    {
        var negative:Bool = false;
        if (Int128.isNegative(i)) {
            i = i.minus();
            negative = true;
        }

        var mul:Int128 = i;
        var sum:Int128 = Int128.alloc();
        var j:Int      = 0;
        while (mul.greater(Int128.ZERO)) {
            if ((untyped mul:Bits)[0]) {
                sum = sum.add(new Int128(this << j));
            }
            mul = mul.urshift(1);
            ++j;
        }

        return negative ? sum.minus() : sum;
    }

    /**
     * TODO: implementation
     *
     * @link http://en.wikipedia.org/wiki/Double_dabble
     * @link http://stackoverflow.com/questions/8023414/how-to-convert-a-128-bit-integer-to-a-decimal-ascii-string-in-c
     * @link http://www.codeobsessed.com/binary-decimal-converters.html
     */
    @:noCompletion
    public function toString():String
    {
        return this.toString();
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:op(A >>> B) public function urshift(times:Int):Int128
    {
        return new Int128(this >>> times);
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    @:commutative
    @:op(A ^ B) public function xor(i:Int128):Int128
    {
        return new Int128(this ^ cast i);
    }
}
