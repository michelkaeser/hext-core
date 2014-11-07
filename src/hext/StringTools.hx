package hext;

import hext.Char;
import hext.IllegalArgumentException;
import hext.StringIterator;

/**
 * The StringTools utilities class adds several helpful methods
 * to the standard String class.
 */
class StringTools
{
    /**
     * Checks if the string contains the substring 'sub'.
     *
     * @param String str the string to search in
     * @param String sub the substring to search
     *
     * @return Bool
     */
    public static function contains(str:String, sub:String):Bool
    {
        return str.indexOf(sub) != -1;
    }

    /**
     * Checks if all string characters are lower-case.
     *
     * Attn: If the string is empty, always true is returned.
     *
     * @param String str the string to check
     *
     * @return Bool true if all is lower
     */
    public static function isLowerCase(str:String):Bool
    {
        for (i in 0...str.length) {
            var c:Char = str.charCodeAt(i);
            if (Char.isLetter(c) && Char.isUpperCase(c)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Checks if all string characters are upper-case.
     *
     * Attn: If the string is empty, always true is returned.
     *
     * @param String str the string to check
     *
     * @return Bool true if all is upper
     */
    public static function isUpperCase(str:String):Bool
    {
        for (i in 0...str.length) {
            var c:Char = str.charCodeAt(i);
            if (Char.isLetter(c) && Char.isLowerCase(c)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Returns an Iterator that can be used to access every character of the String.
     *
     * @param String str the String to iterate over
     *
     * @return hext.StringIterator
     */
    public static inline function iterator(str:String):StringIterator
    {
        return new StringIterator(str);
    }

    /**
     * Reverses all characters of the String and returns the reversed one.
     *
     * This method does not change the input String.
     *
     * @param String str the String to reverse
     *
     * @return String the reversed String
     */
    public static function reverse(str:String):String
    {
        var reverse:StringBuf = new StringBuf();
        for (i in 0...str.length + 1) {
            reverse.add(str.charAt(str.length - i));
        }

        return reverse.toString();
    }

    /**
     * Converts the string to its Bool value.
     *
     * @param str the string to get the Bool value of
     *
     * @return Bool
     *
     * @throws hext.IllegalArgumentException if the string is no valid Bool value
     */
    public static function toBool(str:String):Bool
    {
        if (str != "false" && str != "true") {
            throw new IllegalArgumentException("String is not a valid Bool value.");
        }

        return str == "true";
    }

    /**
     * Returns an Array of all characters of the String.
     *
     * @param String str the String to get the characters from
     *
     * @return Array<hext.Char>
     */
    public static function toCharArray(str:String):Array<Char>
    {
        var chars:Array<Char> = new Array<Char>();
        for (char in StringTools.iterator(str)) {
            chars.push(char);
        }

        return chars;
    }
}
