package hext;

import hext.IllegalArgumentException;
import hext.utils.Reflector;

/**
 * The ListTools utilities class adds several helpful methods
 * to the standard List class.
 */
class ListTools
{
    /**
     * Adds all items from the Iterable to the end of the List.
     *
     * @param List<T>           list  the List to which the items should be added
     * @param Null<Iterable<T>> items the items to add
     */
    public static function addAll<T>(list:List<T>, items:Null<Iterable<T>>):Void
    {
        if (items != null) {
            for (item in items) {
                list.add(item);
            }
        }
    }

    /**
     * Purges the item from the List.
     *
     * A purge means that all references to the item are removed rather than just the first one.
     *
     * @param List<T> list the List to purge the item from
     * @param T       item the item to purge
     *
     * @return Bool true if purged
     */
    public static function purge<T>(list:List<T>, item:T):Bool
    {
        var removed:Bool = list.remove(item);
        while (list.remove(item)) {}

        return removed;
    }

    /**
     * Purges all items defined in 'items' from the List.
     *
     * A purge means that all references to the item are removed rather than just the first one.
     *
     * @param List<T>           list  the List to purge the items from
     * @param Null<Iterable<T>> items the items to purge
     *
     * @return Int the number of purged items
     */
    public static function purgeAll<T>(list:List<T>, items:Null<Iterable<T>>):Int
    {
        var counter:Int = 0;
        if (items != null) {
            for (item in items) {
                if (ListTools.purge(list, item)) {
                    ++counter;
                }
            }
        }

        return counter;
    }

    /**
     * Adds all the items from 'items' to beginning of the List.
     *
     * @param List<T>           list  the List to which the items should be added
     * @param Null<Iterable<T>> items the items to add
     */
    public static function pushAll<T>(list:List<T>, items:Null<Iterable<T>>):Void
    {
        if (items != null) {
            for (item in items) {
                list.push(item);
            }
        }
    }

    /**
     * Removes all items defined in 'items' from the List.
     *
     * @param List<T>           list  the List to remove the items from
     * @param Null<Iterable<T>> items the items to remove
     *
     * @return Int the number of removed items
     */
    public static function removeAll<T>(list:List<T>, items:Null<Iterable<T>>):Int
    {
        var counter:Int = 0;
        if (items != null) {
            for (item in items) {
                if (list.remove(item)) {
                    ++counter;
                }
            }
        }

        return counter;
    }
}
