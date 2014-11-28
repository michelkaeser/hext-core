package hext;

using hext.ArrayTools;

/**
 * The IteratorTools utilities class adds several helpful methods
 * to the Iterator type.
 */
@:final
class IteratorTools
{
    /**
     * Returns an Array containing all items from the Iterator.
     *
     * @param Iterator<T> it the Iterator to get an Array of
     *
     * @return Array<T>
     */
    public static function toArray<T>(it:Iterator<T>):Array<T>
    {
        var arr:Array<T> = new Array<T>();
        while (it.hasNext()) {
            arr.add(it.next());
        }

        return arr;
    }

    /**
     * Returns a List containing all items from the Iterator.
     *
     * @param Iterator<T> it the Iterator to get a List of
     *
     * @return List<T>
     */
    public static function toList<T>(it:Iterator<T>):List<T>
    {
        var list:List<T> = new List<T>();
        while (it.hasNext()) {
            list.add(it.next());
        }

        return list;
    }
}
