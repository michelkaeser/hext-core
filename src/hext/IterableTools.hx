package hext;

import hext.Ref;

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
     * Checks if the Iterable contains all items in 'items'.
     *
     * Note: If 'items' is empty, true is returned.
     *
     * @param Iterable<T>       it    the Iterable to search in
     * @param Iterable<T>       items the items to check
     * @param Null<hext.Ref<T>> fail  if not null, its value will be set to the first item not found
     *
     * @return Bool
     */
    public static function containsAll<T>(it:Iterable<T>, items:Iterable<T>, ?fail:Ref<T>):Bool
    {
        var contains:Bool = true;
        for (item in items) {
            if (!IterableTools.contains(it, item)) {
                contains = false;
                if (fail != null) {
                    fail.val = item;
                }
                break;
            }
        }

        return contains;
    }
}
