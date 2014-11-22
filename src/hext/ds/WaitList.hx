package hext.ds;

import hext.ds.LinkedList;
import hext.ds.IList;
import hext.ds.NoSuchElementException;
import hext.ds.Queue;

/**
 * Use cases:
 *   - FIFO
 */
class WaitList<T> extends Queue<T>
{
    /**
     * Stores the underlaying List used to store items.
     *
     * @var hext.ds.IList<T>
     */
    private var storage:IList<T>;


    /**
     * Constructor to initialize a new WaitList.
     *
     * @param Null<hext.ds.IList<T>> list the underlaying list where items should be stored
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
    @:noCompletion
    override private function get_length():Int
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

        var top:T = this.storage.get(0);
        this.storage.delete(0);

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

        return this.storage.get(0);
    }
}
