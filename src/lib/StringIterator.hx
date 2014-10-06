package lib;

import lib.Char;

using StringTools;

/**
 * Iterator class to traverse all characters of a String.
 *
 * Use cases:
 *   - Reading character by character from an input stream. E.g. in a Scanner/Lexer.
 *
 * @see http://api.haxe.org/Iterator.html
 */
class StringIterator
{
     /**
     * Stores current character index/position.
     *
     * @var Int
     */
    private var position:Int;

    /**
     * Stores the String over which is iterated.
     *
     * @var String
     */
    private var string:String;


    /**
     * Constructor to initialize a new StringIterator.
     *
     * @param String str the String to iterate over
     */
    public function new(str:String):Void
    {
        this.string   = str;
        this.position = 0;
    }

    /**
     * Checks if there is another character remaining.
     *
     * @return Bool true if not yet at the end of the String
     */
    public inline function hasNext():Bool
    {
        return this.position < this.string.length;
    }

    /**
     * Returns the next character of the String.
     *
     * @return lib.Char
     */
    public inline function next():Char
    {
        return this.string.fastCodeAt(this.position++);
    }
}
