package lib;

/**
 * An ArrayRange can be used as a marker of a specified index range
 * for an Array.
 *
 * An example could be if you'd like to remove indexes 5-10 from the Array
 * - you could define that indexes as an ArrayRange and write a matching method.
 */
typedef ArrayRange =
{
    var start:Int;
    var end:Int;
};
