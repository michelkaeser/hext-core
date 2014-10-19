package hext.ds;

import haxe.Serializer;
import haxe.Unserializer;
import hext.Serializable;
import hext.ds.Set;
import hext.util.Comparator;

/**
 * Use cases:
 *   - Needing a DS that does not allow duplicate entries.
 */
class UnsortedSet<T> extends Set<T> implements Serializable
{
    /**
     * Stores the underlaying bag to store the items.
     *
     * @var Array<T>
     */
    private var bag:Array<T>;


    /**
     * Constructor to initialize a new UnsortedSet.
     *
     * @param hext.util.Comparator<T> comparator the comparator to check items for equality.
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
    @:keep
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.bag);
    }

    /**
     * @{inherit}
     */
    @:keep
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.bag = unserializer.unserialize();
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
