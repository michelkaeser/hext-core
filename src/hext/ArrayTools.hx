package hext;

import hext.ArrayRange;
import hext.Failure;
import hext.IllegalArgumentException;
import hext.utils.Reflector;

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
     * Adds all items from the Iterable to the end of the Array.
     *
     * @param Array<T>          arr   the Array to which the items should be added
     * @param Null<Iterable<T>> items the items to add
     *
     * @return hext.ArrayRange range of indexes where the items have been placed
     */
    public static function addAll<T>(arr:Array<T>, items:Null<Iterable<T>>):ArrayRange
    {
        var indexes:ArrayRange = { start: arr.length, end: arr.length };
        if (items != null) {
            for (item in items) {
                ArrayTools.add(arr, item);
            }
            indexes.end = arr.length - 1;
        }

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
    // using instead of IterableTools because of performance
    public static inline function contains<T>(arr:Array<T>, item:T):Bool
    {
        return arr.indexOf(item) != -1;
    }

    /**
     * Checks if the Array contains all items within 'items'.
     *
     * Attn: The search doesn't move forward. So the method will return true for
     * the Array [1, 2] and a search Iterable of [1, 1].
     *
     * If the Iterable is empty, true is returned.
     *
     * @param Array<T>          arr   the Array to search in
     * @param Null<Iterable<T>> items the items to search
     * @param Null<Failure<T>>  fails if set and 'fail' is not null, the method will
     *                          abort at the first item that is not contained and set
     *                          the reference to its value. If 'fails' is not-null (on or the other)
     *                          the method will check all and include all not-contained items within
     *                          the fails Array.
     *
     * @return Bool
     */
    // using instead of IterableTools because of performance
    public static function containsAll<T>(arr:Array<T>, items:Null<Iterable<T>>, ?fails:Failure<T>):Bool
    {
        var contains:Bool = true;
        if (items != null) {
            for (item in items) {
                if (!ArrayTools.contains(arr, item)) {
                    contains = false;
                    if (fails != null) {
                        if (fails.fail == null) {
                            fails.fails.add(item);
                        } else {
                            fails.fail.val = item;
                            break;
                        }
                    }
                }
            }
        }

        return contains;
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
            throw new IllegalArgumentException("Array index cannot be negative.");
        }

        return arr.splice(index, 1);
    }

    /**
     * Deletes the items with the given indexes from the Array.
     *
     * If the indeses iterable contains duplicate values or is longer than 'arr',
     * the behavior is not defined and it can result in errors.
     *
     * @param Array<T>            arr the Array from which the indexes should be deleted
     * @param Null<Iterable<Int>> indexes the indexes to remove
     *
     * @return Array<T> an Array containing all deleted items
     */
    public static function deleteAll<T>(arr:Array<T>, indexes:Null<Iterable<Int>>):Array<T>
    {
        var deleted:Array<T> = new Array<T>();
        if (indexes != null) {
            var _indexes:Array<Int> = Lambda.array(indexes);
            _indexes.sort(Reflector.compare);
            var i:Int = 0;
            while (i < _indexes.length) {
                deleted.push(ArrayTools.delete(arr, _indexes[i] - i)[0]);
                ++i;
            }
        }

        return deleted;
    }

    /**
     * Purges the item from the Array.
     *
     * A purge means that all references to the item are removed rather than just the first one.
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
     * A purge means that all references to the item are removed rather than just the first one.
     *
     * @param Array<T>          arr   the Array to purge the items from
     * @param Null<Iterable<T>> items the items to purge
     *
     * @return Int the number of purged items
     */
    public static function purgeAll<T>(arr:Array<T>, items:Null<Iterable<T>>):Int
    {
        var counter:Int = 0;
        if (items != null) {
            for (item in items) {
                if (ArrayTools.purge(arr, item)) {
                    ++counter;
                }
            }
        }

        return counter;
    }

    /**
     * @see hext.ArrayTools.addAll
     */
    public static function pushAll<T>(arr:Array<T>, items:Null<Iterable<T>>):ArrayRange
    {
        return ArrayTools.addAll(arr, items);
    }

    /**
     * Removes all items defined in 'items' from the Array.
     *
     * @param Array<T>          arr   the Array to remove the items from
     * @param Null<Iterable<T>> items the items to remove
     *
     * @return Int the number of removed items
     */
    public static function removeAll<T>(arr:Array<T>, items:Null<Iterable<T>>):Int
    {
        var counter:Int = 0;
        if (items != null) {
            for (item in items) {
                if (arr.remove(item)) {
                    ++counter;
                }
            }
        }

        return counter;
    }
}
