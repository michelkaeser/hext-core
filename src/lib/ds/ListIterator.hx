package lib.ds;

import lib.ds.IList;

/**
 * Iterator optimized for Lists.
 *
 * @generic T the type of items the list contains
 */
class ListIterator<T>
{
    /**
     * Stores the list to iterate over.
     *
     * @var lib.ds.IList<T>
     */
    private var list:IList<T>;

    /**
     * Stores the current position.
     *
     * @var Int
     */
    private var position:Int;


    /**
     * Constructor to initialize a new ListIterator.
     *
     * @param lib.ds.IList list the IList to iterate over
     */
    public function new(list:IList<T>):Void
    {
        this.list     = list;
        this.position = 0;
    }

    /**
     * Checks if there is another item in the List.
     *
     * @return Bool
     */
    public function hasNext():Bool
    {
        return this.position < this.list.length;
    }

    /**
     * Returns the next item in the List.
     *
     * @return T
     */
    public function next():T
    {
        return this.list.get(this.position++);
    }
}
