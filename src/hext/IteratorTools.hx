package hext;

using hext.ArrayTools;

/**
 *
 */
class IteratorTools
{
    /**
     *
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
     *
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
