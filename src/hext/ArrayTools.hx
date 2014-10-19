package hext;

import hext.ArrayRange;
import hext.IllegalArgumentException;

/**
 * The ArrayTools utilities class adds several helpful methods
 * to the standard Array class.
 */
class ArrayTools
{
    /**
     * Adds the item to the end of the Array.
     *
     * @param Array<T> arr  the Array to which the item should be added
     * @param T        item the item to add
     *
     * @return Int the new length of the Array
     */
    public static inline function add<T>(arr:Array<T>, item:T):Int
    {
        return arr.push(item);
    }

    /**
     * Adds all items from the Iterable to the Array.
     *
     * @param Array<T>    arr   the Array to which the items should be added
     * @param Iterable<T> items the items to add
     *
     * @return hext.ArrayRange range of indexes where the items have been added
     */
    public static function addAll<T>(arr:Array<T>, items:Iterable<T>):ArrayRange
    {
        var indexes:ArrayRange = { start: arr.length, end: -1 };
        for (item in items) {
            arr.push(item);
        }
        indexes.end = arr.length - 1;

        return indexes;
    }

    /**
     * Checks if the Array contains the given item.
     *
     * @param Array<T> arr  the Array to search in
     * @param T        item the item to search
     *
     * @return Bool
     */
    public static inline function contains<T>(arr:Array<T>, item:T):Bool
    {
        return arr.indexOf(item) != -1;
    }

    /**
     * Deletes the item with the given index from the Array.
     *
     * @param Array<T> arr   the Array to delete from
     * @param Int      index the index to delete
     *
     * @return Array<T> the Array of deleted items
     *
     * @throws hext.IllegalArgumentException if the index is negative
     */
    public static function delete<T>(arr:Array<T>, index:Int):Array<T>
    {
        if (index < 0) {
            throw new IllegalArgumentException("Array index cannot be negative");
        }

        return arr.splice(index, 1);
    }

    /**
     * Purges the item from the Array.
     *
     * A purge means that all references to the item are removed
     * rather than just the first one.
     *
     * @param Array<T>  arr  the Array to purge the item from
     * @param T         item the item to purge
     *
     * @return Bool true if purged
     */
    public static function purge<T>(arr:Array<T>, item:T):Bool
    {
        var removed:Bool = arr.remove(item);
        while (arr.remove(item)) {}

        return removed;
    }

    /**
     * Purges all items defined in 'items' from the Array.
     *
     * A purge means that all references to the item are removed
     * rather than just the first one.
     *
     * @param Array<T>    arr   the Array to purge the items from
     * @param Iterable<T> items the items to purge
     *
     * @return Int the number of purge items
     */
    public static function purgeAll<T>(arr:Array<T>, items:Iterable<T>):Int
    {
        var counter:Int = 0;
        for (item in items) {
            if (ArrayTools.purge(arr, item)) {
                ++counter;
            }
        }

        return counter;
    }

    /**
     * Removes all items defined in 'items' from the Array.
     *
     * @param Array<T>    arr   the Array to remove the items from
     * @param Iterable<T> items the items to remove
     *
     * @return Int the number of removed items
     */
    public static function removeAll<T>(arr:Array<T>, items:Iterable<T>):Int
    {
        var counter:Int = 0;
        for (item in items) {
            if (arr.remove(item)) {
                ++counter;
            }
        }

        return counter;
    }
}
