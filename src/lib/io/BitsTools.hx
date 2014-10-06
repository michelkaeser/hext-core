package lib.io;

import haxe.Int32;
import haxe.io.Bytes;
import lib.IllegalArgumentException;
import lib.MathTools;
import lib.io.Bits;

/**
 * The BitsTools utilities class adds several helpful methods to the lib.io.Bits class.
 */
class BitsTools
{
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
     * Returns the Bits of the input string.
     *
     * @param Null<String> str the string to get the bits for
     *
     * @return lib.io.Bits the string's bits
     */
    public static function ofString(str:String):Bits
    {
        if (str == null || str.length == 0) {
            return new Bits(0);
        }

        return Bytes.ofString(str);
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
    public static function toInt32(bits:Bits):Int32
    {
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
     * Converts the Bits back to its string value.
     *
     * @param Null<lib.io.Bits> bits the Bits to get the string value for
     *
     * @return String
     */
    public static function toString(bits:Null<Bits>):String
    {
        if (bits == null || bits.length == 0) {
            return "";
        }

        return (bits:Bytes).toString();
    }
}
