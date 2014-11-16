package hext.io;

import hext.Error;

/**
 * The Bit abstract allows one to treat Bools or Ints like they were a single Bit.
 *
 * They are implemented immutable, so every operation returns a new Bit rather than
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
     * Operator method that is called when anding two Bits.
     *
     * @param hext.io.Bit b the Bit to and with
     *
     * @return hext.io.Bit
     */
    @:noCompletion
    @:op(A & B) public inline function and(b:Bit):Bit
    {
        return this && b;
    }

    /**
     * Operator method that is called when checking two Bits for equality.
     *
     * @param hext.io.Bit b the Bit to check against
     *
     * @return Bool true if they are equal (e.g. both are 1)
     */
    @:noCompletion
    @:op(A == A) public inline function equals(b:Bit):Bool
    {
        return this == b;
    }

    /**
     * Type-casting helper method to convert an Int to a Bit.
     *
     * @param Int value the Int to convert
     *
     * @return hext.io.Bit
     *
     * @throws hext.Error if the Int is not 0 or 1
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
    @:op(~A) public inline function neg():Bit
    {
        return !this;
    }

    /**
     * Operator method that is called when checking two Bits for NOT equality.
     *
     * @param hext.io.Bit b the Bit to check against
     *
     * @return Bool true if they are not equal (e.g. one is 0 and the other 1)
     */
    @:noCompletion
    @:op(A != A) public inline function nequals(b:Bit):Bool
    {
        return this != b;
    }

    /**
     * Operator method that is called when oring two Bits.
     *
     * @param hext.io.Bit b the Bit to or with
     *
     * @return hext.io.Bit
     */
    @:noCompletion
    @:op(A | B) public inline function or(b:Bit):Bit
    {
        return this || b;
    }

    /**
     * Type-casting helper method to convert the Bit to an Int.
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

    /**
     * Operator method that is called when xoring two Bits.
     *
     * @param hext.io.Bit b the Bit to xor with
     *
     * @return hext.io.Bit
     */
    @:noCompletion
    @:op(A ^ B) public inline function xor(b:Bit):Bit
    {
        return (this || b) && (this != b);
    }
}
