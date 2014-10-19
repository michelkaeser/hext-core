package hext;

/**
 * An ArrayRange can be used as a marker of a specified index range
 * for an Array.
 *
 * Use cases:
 *   - Consider a function that is able to remove a whole range from an Array.
 *     Instead of having two parameters (start, end), one can use this typedef.
 */
typedef ArrayRange =
{
    var start:Int;
    var end:Int;
};
