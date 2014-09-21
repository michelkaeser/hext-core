package lib.ds;

import lib.ds.Set;
import lib.util.Comparator;

/**
 *
 */
class UnsortedSet<T> extends Set<T>
{
    /**
     * Stores the underlaying bag to store the items.
     *
     * @param Array<T>
     */
    private var bag:Array<T>;


    /**
     * Constructor to initialize a new UnsortedSet.
     *
     * @param lib.util.Comparator<T> comparator the comparator to check items for equality.
     */
    public function new(comparator:Comparator<T>):Void
    {
        super(comparator);
        this.bag = new Array<T>();
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Bool
    {
        if (this.isEmpty() || !this.contains(item)) {
            this.bag.push(item);
            ++this.size;

            return true;
        }

        return false;
    }

    /**
     * @{inherit}
     */
    override public function iterator():Iterator<T>
    {
        return this.bag.iterator();
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        if (!this.isEmpty() && this.bag.remove(item)) {
            --this.size;
            return true;
        }

        return false;
    }

    /**
     * @{inherit}
     */
    // overriden for better performance than in Collection
    override public function toArray():Array<T>
    {
        return Lambda.array(this.bag);
    }
}
