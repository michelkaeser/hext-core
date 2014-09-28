package lib;

import lib.IllegalArgumentException;

/**
 * Static only class to work with bits and the binary format.
 */
class Binary
{
    /**
     * Returns the binary representation of the input integer.
     *
     * @param Int i the integer to get the bits for
     *
     * @return String
     *
     * @throws lib.IllegalArgumentException if the integer is negative
     */
    public static function ofInt(i:Int):String
    {
        if (i < 0) {
            throw new IllegalArgumentException("Negative numbers cannot be converted to binary.");
        }

        var binary:StringBuf = new StringBuf();
        var exp:Int = 0;
        while (Math.pow(2, ++exp) <= i) {}
        var res:Int;
        while (i >= 0 && --exp >= 0) {
            res = Std.int(Math.pow(2, exp));
            if (i - res >= 0) {
                binary.add('1');
                i -= res;
            } else {
                binary.add('0');
            }
        }

        return binary.toString();
    }

    /**
     * Converts the binary representation back to its int value.
     *
     * @param Null<String> binary the integer bits
     *
     * @return Int
     *
     * @throws lib.IllegalArgumentException if the string is no valid integer representation
     */
    public static function toInt(binary:Null<String>):Int
    {
        if (binary == null || binary.length == 0) {
            throw new IllegalArgumentException("Invalid binary string.");
        }

        var i:Int   = 0;
        var exp:Int = 0;
        for (j in 0...binary.length) {
            if (binary.charCodeAt(j) == '1'.code) {
                i += Std.int(Math.pow(2, binary.length - j - 1));
            }
        }

        return i;
    }
}
