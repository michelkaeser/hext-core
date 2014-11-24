package hext;

import hext.Failure;

/**
 * The IterableTools utilities class adds several helpful methods
 * to Iterable data structures/instances.
 */
class IterableTools
{
    /**
     * Checks if the Iterable contains the given item.
     *
     * @param Iterable<T> it   the Iterable to search in
     * @param T           item the item to search
     *
     * @return Bool
     */
    public static inline function contains<T>(it:Iterable<T>, item:T):Bool
    {
        return Lambda.has(it, item);
    }

    /**
     * Checks if the Iterable contains all items within 'items'.
     *
     * Attn: The search doesn't move forward. So the method will return true for
     * the Iterable [1, 2] and a search Iterable of [1, 1].
     *
     * If the Iterable is empty, true is returned.
     *
     * @param Iterable<T>       it    the Iterable to search in
     * @param Null<Iterable<T>> items the items to search
     * @param Null<Failure<T>>  fails if set and 'fail' is not null, the method will
     *                          abort at the first item that is not contained and set
     *                          the reference to its value. If 'fails' is not-null (on or the other)
     *                          the method will check all and include all not-contained items within
     *                          the fails Array.
     *
     * @return Bool
     */
    public static function containsAll<T>(it:Iterable<T>, items:Null<Iterable<T>>, ?fails:Failure<T>):Bool
    {
        var contains:Bool = true;
        if (items != null) {
            for (item in items) {
                if (!IterableTools.contains(it, item)) {
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
     * Checks if the Iterable is empty.
     *
     * @see http://api.haxe.org/Lambda.html#empty
     *
     * @param Iterable<T> it the Iterable to check
     *
     * @return Bool
     */
    public static inline function isEmpty(it:Iterable<Dynamic>):Bool
    {
        return Lambda.empty(it);
    }

    /**
     * Returns an Array containing all items from the Iterable.
     *
     * If the Iterable is an Array, a copy is returned.
     *
     * @see http://api.haxe.org/Lambda.html#array
     *
     * @param Iterable<T> it the Iterable to get an Array of
     *
     * @return Array<T>
     */
    public static inline function toArray<T>(it:Iterable<T>):Array<T>
    {
        return Lambda.array(it);
    }

    /**
     * Returns a List containing all items from the Iterable.
     *
     * If the Iterable is a List, a copy is returned.
     *
     * @see http://api.haxe.org/Lambda.html#list
     *
     * @param Iterable<T> it the Iterable to get a List of
     *
     * @return List<T>
     */
    public static inline function toList<T>(it:Iterable<T>):List<T>
    {
        return Lambda.list(it);
    }
}
