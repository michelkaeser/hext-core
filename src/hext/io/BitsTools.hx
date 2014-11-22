package hext.io;

import haxe.Int32;
import haxe.Int64;
import haxe.io.Bytes;
import hext.IllegalArgumentException;
import hext.Int128;
import hext.MathTools;
import hext.UnsupportedOperationException;
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
     * @param Null<String> str the string with the binary bits (e.g. "01001")
     *
     * @return hext.io.Bits
     *
     * @throws hext.IllegalArgumentException if the str contains invalid characters
     */
    @:noUsing
    public static function fromBinaryString(str:Null<String>):Bits
    {
        var bits:Bits;
        if (str == null || str.length == 0) {
            bits = Bits.alloc(0);
        } else {
            bits = Bits.alloc(str.length);
            for (i in 0...str.length) {
                var code:Int = str.fastCodeAt(str.length - i - 1);
                if (code == '0'.code) {
                    bits[i] = (0:Bit);
                } else if (code == '1'.code) {
                    bits[i] = (1:Bit);
                } else {
                    throw new IllegalArgumentException("Invalid binary character detected in input string.");
                }
            }
        }

        return bits;
    }

    /**
     * Returns a Bits instance with the bits from the input string.
     *
     * @param Null<String> str the string with the octal bits (e.g. "770")
     *
     * @return hext.io.Bits
     *
     * @throws hext.IllegalArgumentException if the str contains invalid characters
     */
    @:noUsing
    public static function fromOctalString(str:Null<String>):Bits
    {
        var bits:Bits;
        if (str == null || str.length == 0) {
            bits = Bits.alloc(0);
        } else {
            bits = Bits.alloc(str.length * 3);
            var index:Int = 0;
            for (i in 0...str.length) {
                var code:Int = str.fastCodeAt(str.length - i - 1);
                switch (code) {
                    case '0'.code: // nothing to do
                    case '1'.code: {
                        bits[index] = (1:Bit);
                    }
                    case '2'.code: {
                        bits[index + 1] = (1:Bit);
                    }
                    case '3'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                    }
                    case '4'.code: {
                        bits[index + 2] = (1:Bit);
                    }
                    case '5'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    case '6'.code: {
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    case '7'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    default: throw new IllegalArgumentException("Invalid octal character detected in input string.");
                }
                index += 3;
            }
        }

        return bits;
    }

    /**
     * Returns a Bits instance with the bits from the input string.
     *
     * @param Null<String> str the string with the hex bits (e.g. "A1")
     *
     * @return hext.io.Bits
     *
     * @throws hext.IllegalArgumentException if the str contains invalid characters
     */
    @:noUsing
    public static function fromHexString(str:Null<String>):Bits
    {
        var bits:Bits;
        if (str == null || str.length == 0) {
            bits = Bits.alloc(0);
        } else {
            bits = Bits.alloc(str.length << 2);
            var index:Int = 0;
            for (i in 0...str.length) {
                var code:Int = str.fastCodeAt(str.length - i - 1);
                switch (code) {
                    case '0'.code: // nothing to do
                    case '1'.code: {
                        bits[index] = (1:Bit);
                    }
                    case '2'.code: {
                        bits[index + 1] = (1:Bit);
                    }
                    case '3'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                    }
                    case '4'.code: {
                        bits[index + 2] = (1:Bit);
                    }
                    case '5'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    case '6'.code: {
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    case '7'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                    }
                    case '8'.code: {
                        bits[index + 3] = (1:Bit);
                    }
                    case '9'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'A'.code: {
                        bits[index + 1] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'B'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'C'.code: {
                        bits[index + 2] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'D'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 2] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'E'.code: {
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    case 'F'.code: {
                        bits[index]     = (1:Bit);
                        bits[index + 1] = (1:Bit);
                        bits[index + 2] = (1:Bit);
                        bits[index + 3] = (1:Bit);
                    }
                    default: throw new IllegalArgumentException("Invalid hexadecimal character detected in input string.");
                }
                index += 4;
            }
        }

        return bits;
    }

    /**
     * Returns a Bits instance with the bits from the input string.
     *
     * @param Null<String> str  the string with the bits (e.g. "01001" or "FF")
     * @param Int          base the base (e.g. decimal = 10, binary = 2) of the input string
     *
     * @return hext.io.Bits
     *
     * @throws hext.UnsupportedOperationException if base system is not supported
     */
    @:noUsing
    public static function fromString(str:Null<String>, base:Int = 2):Bits
    {
        if (base != 2 && base != 8 && base != 16) {
            throw new UnsupportedOperationException("Unsupported base. Only binary(2), octal(8) and hexadecimal(16) are supported.");
        }

        var bits:Bits;
        if (str == null || str.length == 0) {
            bits = Bits.alloc(0);
        } else {
            bits = switch (base) {
                case  2: BitsTools.fromBinaryString(str);
                case  8: BitsTools.fromOctalString(str);
                case 16: BitsTools.fromHexString(str);
                default: // not reached
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
    @:noUsing
    public static function ofFloat(f:Float):Bits
    {
        var bits:Bytes = Bits.alloc(64);
        bits.setDouble(0, f);

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
    @:noUsing
    public static function ofInt32(i:Int32):Bits
    {
        var bits:Bytes = Bits.alloc(32);
        for (j in 0...4) {
            bits.set(j, i >>> (j * 8));
        }

        return bits;
    }

    /**
     * Returns the Bits of the input Int (64bit variant).
     *
     * @link http://en.wikipedia.org/wiki/Two's_complement is used for negatie values
     *
     * @param haxe.Int64 i the Int to get the bits for
     *
     * @return hext.io.Bits the Int's Bits
     */
    @:noUsing
    public static function ofInt64(i:Int64):Bits
    {
        var bits:Bytes = Bits.alloc(64);
        for (j in 0...8) {
            bits.set(j, Int64.toInt(Int64.shr(i, j * 8)));
        }

        return bits;
    }

    /**
     * Returns the Bits of the input Int (128bit variant).
     *
     * @link http://en.wikipedia.org/wiki/Two's_complement is used for negatie values
     *
     * @param hext.Int128 i the Int to get the bits for
     *
     * @return hext.io.Bits the Int's Bits
     */
    @:noUsing
    public static function ofInt128(i:Int128):Bits
    {
        return (untyped i.bits:Bits).copy();
    }

    /**
     * Returns the Bits of the input string.
     *
     * @param Null<String> str the string to get the bits for
     *
     * @return hext.io.Bits the string's bits
     */
    @:noUsing
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
     * Converts the Bits back to its Int64 value.
     *
     * @param hext.io.Bits bits the Bits to get the Int64 value for
     *
     * @return haxe.Int64
     *
     * @throws hext.IllegalArgumentException if the bits are not from an Int64
     */
    public static function toInt64(bits:Bits):Int64
    {
        if (bits == null || bits.length != 8) {
            throw new IllegalArgumentException("Bits are not a valid Int64 value.");
        }

        var i:Int64 = Int64.ofInt(0);
        for (j in 0...8) {
            var k:Int64 = Int64.ofInt((bits:Bytes).get(j));
            i = Int64.or(i, Int64.shl(k, j * 8));
        }

        return i;
    }

    /**
     * Converts the Bits back to its Int128 value.
     *
     * @param hext.io.Bits bits the Bits to get the Int128 value for
     *
     * @return hext.Int128
     *
     * @throws hext.IllegalArgumentException if the bits are not from an Int128
     */
    @:access(hext.Int128)
    public static function toInt128(bits:Bits):Int128
    {
        if (bits == null || bits.length != 16) {
            throw new IllegalArgumentException("Bits are not a valid Int128 value.");
        }

        return new Int128(bits.copy());
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
