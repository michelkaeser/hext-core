package lib.ds;

import lib.ds.IList;

/**
 *
 */
class ListIterator<T>
{
    /**
     *
     */
    private var list:IList<T>;

    /**
     *
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
     * Returns the next item in the List.
     *
     * @return T
     */
    public function next():T
    {
        return this.list.get(this.position++);
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
}
