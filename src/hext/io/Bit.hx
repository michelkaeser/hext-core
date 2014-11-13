package hext.io;

import hext.Error;

/**
 * The Bit abstract allows one to treat Bools or Ints like they were a single Bit.
 *
 * They are implemented immutable, meaning, that every operation returns a new Bit rather than
 * manipulating the existing one in-place.
 *
 * Use cases:
 *   - Working on a low-level system class (e.g. unfiltered storage access) and the data returned
 *     by member methods should feel natural. Bits should help...
 */
abstract Bit(Bool) from Bool to Bool
{
    /**
     * Constructor to initialize a new Bit.
     *
     * @param Bool value the Bit's value (true == 1)
     */
    private inline function new(value:Bool):Void
    {
        this = value;
    }

    /**
     * Overloaded operator that is called when comparing two Bits.
     *
     * @param hext.io.Bit b the Bit to compare against
     *
     * @return Bool true if they are equal (e.g. both are 1)
     */
    @:noCompletion
    @:op(A == A) public inline function compareEqual(b:Bit):Bool
    {
        return (this:Bool) == b;
    }

    /**
     * Overloaded operator that is called when comparing for NE two Bits.
     *
     * @param hext.io.Bit b the Bit to compare against
     *
     * @return Bool true if they are not equal (e.g. one is 1, the other 0)
     */
    @:noCompletion
    @:op(A != A) public inline function compareNotEqual(b:Bit):Bool
    {
        return (this:Bool) != b;
    }

    /**
     * Type-casting helper method to convert an integer to a Bit.
     *
     * @param Int value the integer value to convert
     *
     * @return hext.io.Bit
     *
     * @throws hext.Error if the integer is not 0 or 1
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt(i:Int):Bit
    {
        #if !HEXT_PERFORMANCE
            if (i != 0 && i != 1) {
                throw new Error("A bit can either be 0 or 1.");
            }
        #end

        return new Bit(i == 1);
    }

    /**
     * Returns the negated Bit.
     *
     * @return hext.io.Bit
     */
    @:noCompletion
    @:op(!A) public inline function negate():Bit
    {
        return !this;
    }

    /**
     * Type-casting helper method to convert the Bit to an integer.
     *
     * @return Int
     */
    @:noCompletion
    @:to public #if HEXT_PERFORMANCE inline #end function toInt():Int
    {
        return (this == true) ? 1 : 0;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    public function toString():String
    {
        return (this == true) ? "1" : "0";
    }
}
