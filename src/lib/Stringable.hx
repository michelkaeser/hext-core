package lib;

/**
 * The Stringifyable interfaces acts as a marker interface.
 *
 * Implementing classes should return a string that matches the object's data.
 * For example a "two pair" Point could return something like "x: 10, y: 9".
 */
interface Stringable
{
    /**
     * Returns a String representing the current instance.
     *
     * @return String
     */
    public function toString():String;
}
