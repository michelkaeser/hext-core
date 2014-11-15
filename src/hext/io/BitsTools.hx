package hext.io;

import haxe.Int32;
import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.MathTools;
import hext.io.Bits;

using StringTools;

/**
 * The BitsTools utilities class adds several helpful methods to the hext.io.Bits class.
 */
class BitsTools
{
    /**
     * Returns a Bits instance with the bits from the input string.
     *
     * @param Null<String> str the string with the bits (e.g. "01001")
     *
     * @return hext.io.Bits
     *
     * @throws hext.IllegalArgumentException if the str contains chars other chan 0 or 1
     */
    public static function fromString(str:Null<String>):Bits
    {
        var bits:Bits;
        if (str == null || str.length == 0) {
            bits = Bits.alloc(0);
        } else {
            var length:Int = str.length;
            bits = Bits.alloc(length);
            for (i in 0...length) {
                var code:Int = str.fastCodeAt(length - i - 1);
                if (code == '0'.code) {
                    bits[i] = (0:Bit);
                } else if (code == '1'.code) {
                    bits[i] = (1:Bit);
                } else {
                    throw new IllegalArgumentException("Invalid Bit character detected in input string.");
                }
            }
        }

        return bits;
    }

    /**
     * Returns the Bits of the input float (64bit double).
     *
     * @link http://en.wikipedia.org/wiki/Double-precision_floating-point_format is used
     *
     * @param Float f the float to get the bits for
     *
     * @return hext.io.Bits the float's Bits
     */
    public static function ofFloat(f:Float):Bits
    {
        var bits:Bits = Bits.alloc(64);
        (bits:Bytes).setDouble(0, f);

        return bits;
    }

    /**
     * Returns the Bits of the input Int (32bit variant).
     *
     * @link http://en.wikipedia.org/wiki/Two's_complement is used for negatie values
     *
     * @param haxe.Int32 i the Int to get the bits for
     *
     * @return hext.io.Bits the Int's Bits
     */
    public static function ofInt32(i:Int32):Bits
    {
        var bits:Bits = Bits.alloc(32);
        if (i == MathTools.MIN_INT32) {
            bits.flip(31);
        } else if (i != 0) {
            for (j in 0...4) {
                (bits:Bytes).set(j, i >> (j * 8));
            }
        }

        return bits;
    }

    /**
     * Returns the Bits of the input string.
     *
     * @param Null<String> str the string to get the bits for
     *
     * @return hext.io.Bits the string's bits
     */
    public static function ofString(str:Null<String>):Bits
    {
        if (str == null || str.length == 0) {
            return Bits.alloc(0);
        }

        return Bytes.ofString(str);
    }

    /**
     * Converts the Bits back to its Float value.
     *
     * @param hext.io.Bits bits the Bits to get the Float value for
     *
     * @return Float
     *
     * @throws hext.IllegalArgumentException if the bits are not from a Float
     */
    public static function toFloat(bits:Bits):Float
    {
        if (bits == null || bits.length != 8) {
            throw new IllegalArgumentException("Bits are not a valid Float value.");
        }

        return (bits:Bytes).getDouble(0);
    }

    /**
     * Converts the Bits back to its Int32 value.
     *
     * @param hext.io.Bits bits the Bits to get the Int32 value for
     *
     * @return haxe.Int32
     *
     * @throws hext.IllegalArgumentException if the bits are not from an Int32
     */
    public static function toInt32(bits:Bits):Int32
    {
        if (bits == null || bits.length != 4) {
            throw new IllegalArgumentException("Bits are not a valid Int32 value.");
        }

        var i:Int32 = 0;
        for (j in 0...4) {
            i |= (bits:Bytes).get(j) << (j * 8);
        }

        return i;
    }

    /**
     * Converts the Bits back to its string value.
     *
     * @param Null<hext.io.Bits> bits the Bits to get the string value for
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
