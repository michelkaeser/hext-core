package lib.ds;

import lib.ds.LinkedList;
import lib.ds.IList;
import lib.ds.NoSuchElementException;
import lib.ds.Queue;

/**
 *
 */
class Stack<T> extends Queue<T>
{
    /**
     * Stores the underlaying List used to store items.
     *
     * @param lib.ds.IList<T>
     */
    private var storage:IList<T>;


    /**
     * Constructor to initialize a new Stack.
     *
     * @param lib.ds.IList<T> list the underlaying List to use
     */
    public function new(?list:IList<T>):Void
    {
        super();

        if (list == null) {
            list = new LinkedList<T>();
        }
        this.storage = list;
    }

    /**
     * @{inherit}
     */
    override private inline function get_length():Int
    {
        return this.storage.length;
    }

    /**
     * @{inherit}
     */
    override public function pop():T
    {
        if (this.isEmpty()) {
            throw new NoSuchElementException();
        }

        var top:T = this.storage.get(this.length - 1);
        this.storage.delete(this.length - 1);

        return top;
    }

    /**
     * @{inherit}
     */
    override public function push(item:T):Int
    {
        this.storage.add(item);
        return this.length;
    }

    /**
     * @{inherit}
     */
    override public function top():T
    {
        if (this.isEmpty()) {
            throw new NoSuchElementException();
        }

        return this.storage.get(this.length - 1);
    }
}
