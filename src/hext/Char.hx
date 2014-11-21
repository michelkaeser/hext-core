package hext;

import haxe.io.Bytes;
import hext.Error;

using StringTools;

/**
 * Abstract C++/Java like single character representation.
 *
 * They are implemented immutable, so every operation returns a new Char rather than
 * manipulating the existing one in-place.
 *
 * Use cases:
 *   - Reading/writing from/to streams. Working with characters might feel more natural than integers.
 */
abstract Char(Bytes) from Bytes to Bytes
{
    /**
     * Constructor to initialize a new Char.
     *
     * @param Bytes bytes the Bytes to use as an underlaying structure
     */
    private inline function new(bytes:Bytes):Void
    {
        this = bytes;
    }

    /**
     * Operator method that is called when adding two Chars.
     *
     * @param hext.Char c the char to add
     *
     * @return hext.Char
     */
    @:noCompletion
    @:commutative
    @:op(A + B) public function add(c:Char):Char
    {
        return this.get(0) + c.toInt();
    }

    /**
     * Operator method that is called when checking two Chars for equality.
     *
     * @param hext.Char c the char to check against
     *
     * @return hext.Char
     */
    @:noCompletion
    @:commutative
    @:op(A == B) public function equals(c:Char):Bool
    {
        return this.get(0) == c.toInt();
    }

    /**
     * Type-casting helper method to cast the Int to a Char.
     *
     * @param Int i the Int to cast
     *
     * @return hext.Char
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt(i:Int):Char
    {
        var bytes:Bytes = Bytes.alloc(1);
        bytes.set(0, i);

        return new Char(bytes);
    }

    /**
     * Type-casting helper method to cast the string to a Char.
     *
     * @param String str the string to cast
     *
     * @return hext.Char
     *
     * @throws hext.Error is the string has more than one character
     */
    @:noCompletion @:noUsing
    @:from public static function fromString(str:String):Char
    {
        if (str.length > 1) {
            throw new Error("Unclosed character literal.");
        }

        return new Char(Bytes.ofString(str));
    }

    /**
     * Operator method that is called when checking for "is greater than" against another Char.
     *
     * @param hext.Char c the char to check against
     *
     * @return hext.Char
     */
    @:noCompletion
    @:op(A > B) public function greater(c:Char):Bool
    {
        return this.get(0) > c.toInt();
    }

    /**
     * Checks if the passed character is a digit.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isDigit(c:Char):Bool
    {
        return (c:Int) >= '0'.code && (c:Int) <= '9'.code;
    }

    /**
     * Checks if the passed character is a letter.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isLetter(c:Char):Bool
    {
        return Char.isLowerCase(c) || Char.isUpperCase(c);
    }

    /**
     * Checks if the character is a lower case letter.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isLowerCase(c:Char):Bool
    {
        return (c:Int) >= 'a'.code && (c:Int) <= 'z'.code;
    }

    /**
     * Checks if the passed character is a line-separator.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isLineSeparator(c:Char):Bool
    {
        return (c:Int) == '\n'.code || (c:Int) == '\r'.code;
    }

    /**
     * Checks if the character is an upper case letter.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isUpperCase(c:Char):Bool
    {
        return (c:Int) >= 'A'.code && (c:Int) <= 'Z'.code;
    }

    /**
     * Checks if the passed character is a special one (not digit, letter or whitespace).
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isSpecial(c:Char):Bool
    {
        return !Char.isDigit(c) && !Char.isLetter(c) && !Char.isWhiteSpace(c);
    }

    /**
     * Checks if the passed character is a whitespace char.
     *
     * @param hext.Char c the char to check
     *
     * @return Bool
     */
    public static function isWhiteSpace(c:Char):Bool
    {
        return (c:Int) == ' '.code || (c:Int) == '\t'.code || Char.isLineSeparator(c);
    }

    /**
     * Operator method that is called when checking for "is less than" against another Char.
     *
     * @param hext.Char c the char to check against
     *
     * @return hext.Char
     */
    @:noCompletion
    @:op(A < B) public function less(c:Char):Bool
    {
        return this.get(0) < c.toInt();
    }

    /**
     * Operator method that is called when checking two Chars for not equality.
     *
     * @param hext.Char c the char to check against
     *
     * @return hext.Char
     */
    @:noCompletion
    @:commutative
    @:op(A != B) public function nequals(c:Char):Bool
    {
        return this.get(0) != c.toInt();
    }

    /**
     * Operator method that is called when substracting one Char from another.
     *
     * @param hext.Char c the char to substract
     *
     * @return hext.Char
     */
    @:noCompletion
    @:op(A - B) public function subs(c:Char):Char
    {
        return this.get(0) - c.toInt();
    }

    /**
     * Type-casting helper method to cast the Char to an Int.
     *
     * @return Int
     */
    @:noCompletion
    @:to public #if HEXT_PERFORMANCE #end function toInt():Int
    {
        return this.get(0);
    }

    /**
     * Converts the upper-case character to its lower-case equivalent.
     *
     * @param hext.Char c the char to convert
     *
     * @return hext.Char the lower-case character
     *
     * @throws hext.IllegalArgumentException if the character is not a letter
     */
    public static function toLowerCase(c:Char):Char
    {
        if (Char.isLetter(c)) {
            var lower:Char = c;
            if (Char.isUpperCase(c)) {
                lower += 32;
            }

            return lower;
        }

        throw new IllegalArgumentException("Character is not a valid letter.");
    }

    /**
     * Type-casting helper method to cast the Char to a string.
     *
     * @return String
     */
    @:noCompletion
    @:to public function toString():String
    {
        return String.fromCharCode(this.get(0));
    }

    /**
     * Converts the lower-case character to its upper-case equivalent.
     *
     * @param hext.Char c the character to convert
     *
     * @return hext.Char the upper-case character
     *
     * @throws hext.IllegalArgumentException if the character is not a letter
     */
    public static function toUpperCase(c:Char):Char
    {
        if (Char.isLetter(c)) {
            var upper:Char = c;
            if (Char.isLowerCase(c)) {
                upper -= 32;
            }

            return upper;
        }

        throw new IllegalArgumentException("Character is not a valid letter.");
    }
}
