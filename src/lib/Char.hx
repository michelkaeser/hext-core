package lib;

import haxe.io.Bytes;
import lib.Error;

using StringTools;

/**
 * Abstract C++/Java like single character representation.
 */
@:forward(get, set)
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
     * Overloaded operator used when adding and assigning two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A += B) public function addAssignChar(c:Char):Char
    {
        this.set(0, (this:Char) + (c:Int));
        return this;
    }

    /**
     * Overloaded operator used when adding two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A + B) public inline function addChar(c:Char):Char
    {
        return cast(this, Int) + (c:Int);
    }

    /**
     * Overloaded operator used when checking if the Chars are equal.
     *
     * @param lib.Char c the Character to compare against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A == B) public inline function compareEqualChar(c:Char):Bool
    {
        return cast(this, Int) == (c:Int);
    }

    /**
     * Overloaded operator used when comparing two Chars for "greater than".
     *
     * @param lib.Char c the Character to check for "greaterness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A > B) public inline function compareGreaterChar(c:Char):Bool
    {
        return cast(this, Int) > (c:Int);
    }

    /**
     * Overloaded operator used when comparing two Chars for "less than".
     *
     * @param lib.Char c the Character to check for "lessness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A < B) public inline function compareLessChar(c:Char):Bool
    {
        return cast(this, Int) < (c:Int);
    }

    /**
     * Overloaded operator used when dividing a Character by another Character.
     *
     * @param lib.Char c the Character to divide by
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A / B) public inline function divideByChar(c:Char):Char
    {
        return Std.int(cast(this, Int) / (c:Int));
    }

    /**
     * Checks if the passed character is a digit.
     *
     * @param lib.Char c the char to check
     *
     * @return true if the character is a digit
     */
    public static function isDigit(c:Char):Bool
    {
        return (c:Int) >= '0'.code && (c:Int) <= '9'.code;
    }

    /**
     * Checks if the passed character is a letter.
     *
     * @param lib.Char c the char to check
     *
     * @return true if the character is a letter
     */
    public static function isLetter(c:Char):Bool
    {
        return ((c:Int) >= 'a'.code && (c:Int) <= 'z'.code) || ((c:Int) >= 'A'.code && (c:Int) <= 'Z'.code);
    }

    /**
     * Checks if the passed character is a line-separator.
     *
     * @param lib.Char c the char to check
     *
     * @return true if the character is one
     */
    public static function isLineSeparator(c:Char):Bool
    {
        return (c:Int) == '\n'.code || (c:Int) == '\r'.code;
    }

    /**
     * Checks if the passed character is a special one (not digit, letter or whitespace).
     *
     * @param lib.Char c the char to check
     *
     * @return true if the character is a special one
     */
    public static function isSpecial(c:Char):Bool
    {
        return !Char.isDigit(c) && !Char.isLetter(c) && !Char.isWhiteSpace(c);
    }

    /**
     * Checks if the passed character is a whitespace char.
     *
     * @param lib.Char c the char to check
     *
     * @return true if the character is whitespace
     */
    public static function isWhiteSpace(c:Char):Bool
    {
        return (c:Int) == ' '.code || (c:Int) == '\t'.code || Char.isLineSeparator(c);
    }

    /**
     * Overloaded operator used when multiplying a Character by another Character.
     *
     * @param lib.Char c the Character to multiply by
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A * B) public inline function multiplyByChar(c:Char):Char
    {
        return Std.int(cast(this, Int) * (c:Int));
    }

    /**
     * Post decrements the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A--) public function postDecrement():Char
    {
        var cur:Int = cast(this, Int);
        this.set(0, cur - 1);

        return cur;
    }

    /**
     * Post increments the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A++) public function postIncrement():Char
    {
        var cur:Int = cast(this, Int);
        this.set(0, cur + 1);

        return cur;
    }

    /**
     * Pre decrements the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(--A) public function preDecrement():Char
    {
        this.set(0, cast(this, Int) - 1);
        return this;
    }

    /**
     * Pre increment the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(++A) public function preIncrement():Char
    {
        this.set(0, cast(this, Int) + 1);
        return this;
    }

    /**
     * Overloaded operator used when substracting and assigning two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A -= B) public function subsAssignChar(c:Char):Char
    {
        this.set(0, cast(this, Int) - (c:Int));
        return this;
    }

    /**
     * Overloaded operator used when substracting one Char from another.
     *
     * @param lib.Char c the Character to substract
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A - B) public inline function subsChar(c:Char):Char
    {
        return cast(this, Int) - (c:Int);
    }

    /**
     * Implicit casting from Bytes to Char.
     *
     * @param Bytes b the bytes to cast
     *
     * @return lib.Char
     */
    @:noCompletion @:noUsing
    @:from public static inline function fromBytes(b:Bytes):Char
    {
        return new Char(b);
    }

    /**
     * Implicit casting from Int to Char.
     *
     * @param Int i the Int to cast
     *
     * @return lib.Char
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt(i:Int):Char
    {
        var bytes:Bytes = Bytes.alloc(1);
        bytes.set(0, i);

        return new Char(bytes);
    }

    /**
     * Implicit casting from String to Char.
     *
     * @param String str the String character to cast
     *
     * @return lib.Char
     *
     * @throws lib.error is the string is longer than 1 character
     */
    @:noCompletion @:noUsing
    @:from public static function fromString(str:String):Char
    {
        if (str.length > 1) {
            throw new Error("Unclosed character literal");
        }

        return new Char(Bytes.ofString(str));
    }

    /**
     * Implicit casting from Char to Bytes.
     *
     * @return Bytes the bytes to store the character code
     */
    @:noCompletion
    @:to public inline function toBytes():Bytes
    {
        return this;
    }

    /**
     * Implicit casting from Char to Int.
     *
     * @return Int the character code
     */
    @:noCompletion
    @:to public inline function toInt():Int
    {
        return this.get(0);
    }

    /**
     * Implicit casting from Char to String.
     *
     * @return String the unicode character behind the char code
     */
    @:noCompletion
    @:to public inline function toString():String
    {
        return String.fromCharCode(cast(this, Int));
    }
}
