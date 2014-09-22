package lib.ds;

import lib.IllegalArgumentException;
import lib.ds.IndexOutOfBoundsException;
import lib.ds.List;

using lib.ArrayTools;

/**
 * IList implementation using an Array as the underlaying data structure,
 * thus allowing fast random access.
 */
class ArrayList<T> extends List<T>
{
    /**
     * Stores the underlaying Array that is wrapped as a List.
     *
     * @var Array<T>
     */
    private var array:Array<T>;


    /**
     * Constructor to initialize a new ArrayList.
     */
    public function new():Void
    {
        super();
        this.array = new Array<T>();
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Bool
    {
        this.array[this.size++] = item;
        return true;
    }

    /**
     * @{inherit}
     */
    override public function clear():Void
    {
        super.clear();
        this.array = new Array<T>();
    }

    /**
     * @{inherit}
     */
    override public function delete(index:Int):Void
    {
        if (index >= this.length) {
            throw new IndexOutOfBoundsException("Index '" + index + "' passed to delete() is out of range ('" + this.length + "')");
        }

        this.array.delete(index);
        --this.size;
    }

    /**
     * @{inherit}
     */
    override public function get(index:Int):T
    {
        if (index >= this.length) {
            throw new IndexOutOfBoundsException("Index '" + index + "' passed to get() is out of range ('" + this.length + "').");
        }

        return this.array[index];
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        if (!this.isEmpty()) {
            if (this.array.purge(item)) {
                --this.size;
                return true;
            }
        }

        return false;
    }

    /**
     * @{inherit}
     */
    override public function set(index:Int, item:T):T
    {
        if (index > this.length) {
            throw new IndexOutOfBoundsException("Index '" + index + "' passed to set() is out of range ('" + this.length + "').");
        } else if (index == this.length) {
            this.add(item);
        } else {
            this.array[index] = item;
        }

        return item;
    }

    /**
     * @{inherit}
     */
    // overriden for better performance than in List
    override public function subList(start:Int, end:Int):ArrayList<T>
    {
        if (end < start) {
            throw new IllegalArgumentException("End index cannot be less than start");
        }

        if (end > this.length) {
            throw new IndexOutOfBoundsException("End index cannot be greater than the List's length");
        }

        var sub:ArrayList<T> = new ArrayList<T>();
        sub.array = this.array.slice(start, end);
        sub.size  = sub.array.length;

        return sub;
    }

    /**
     * @{inherit}
     */
    // overriden for better performance than in Collection
    override public function toArray():Array<T>
    {
        return Lambda.array(this.array);
    }
}
