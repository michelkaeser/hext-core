package lib;

import haxe.Int32;

/**
 * Static only extension class for the standard Math class.
 */
class MathTools
{
    /**
     * Stores the Int32's max value.
     *
     * @var haxe.Int32
     */
    public static inline var MAX_INT32:Int32 = (1 << 31) - 1;

    /**
     * Stores the Int32's min value.
     *
     * @var haxe.Int32
     */
    public static inline var MIN_INT32:Int32 = (1 << 31);
}