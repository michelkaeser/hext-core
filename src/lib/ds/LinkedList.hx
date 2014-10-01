package lib.ds;

import lib.ds.IndexOutOfBoundsException;
import lib.ds.List;
import lib.ds.ListIterator;

/**
 * IList implementation using linked elements.
 *
 * LinkedList is a good choice if you need a dynamic growing IList,
 * as adding new items is easy and fast.
 * If you need an IList with fast random access, you'd better use an lib.ds.ArrayList.
 */
class LinkedList<T> extends List<T>
{
    /**
     * Stores an anchor element used to access the first item in the List.
     *
     * @var lib.ds.LinkedList.Element<T>
     */
    @:allow(lib.ds.LinkedList.Iterator)
    private var anchor:Element<T>;


    /**
     * Constructor to initialize a new LinkedList.
     */
    public function new():Void
    {
        super();

        this.anchor      = new Element<T>();
        this.anchor.next = this.anchor;
        this.anchor.prev = this.anchor;
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Bool
    {
        var element:Element<T> = new Element<T>(item);
        element.next           = this.anchor;
        element.prev           = this.anchor.prev;

        this.anchor.prev.next  = element;
        this.anchor.prev       = element;

        ++this.size;
        return true;
    }

    /**
     * @{inherit}
     */
    override public function contains(item:T):Bool
    {
        if (!this.isEmpty()) {
            var current:Element<T> = this.anchor.next;
            while (current != this.anchor && current.data != item) {
                current = current.next;
            }

            return current.data == item;
        }

        return false;
    }

    /**
     * @{inherit}
     */
    override public function clear():Void
    {
        super.clear();
        this.anchor.next = this.anchor;
        this.anchor.prev = this.anchor;
    }

    /**
     * @{inherit}
     */
    override public function delete(index:Int):Void
    {
        if (index >= this.length) {
            throw new IndexOutOfBoundsException("Index '" + index + "' passed to delete() is out of range ('" + this.length + "').");
        }

        var current:Element<T>;
        if (index < (this.length / 2)) {
            current = this.anchor.next;
            for (i in 0...index) {
                current = current.next;
            }
        } else {
            current = this.anchor.prev;
            var limit:Int = this.length - 1;
            for (i in index...limit) {
                current = current.prev;
            }
        }
        current.prev.next = current.next;
        current.next.prev = current.prev;

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

        var current:Element<T>;
        if (index < (this.length / 2)) {
            current = this.anchor.next;
            for (i in 0...index) {
                current = current.next;
            }
        } else {
            current = this.anchor.prev;
            var limit:Int = this.length - 1;
            for (i in index...limit) {
                current = current.prev;
            }
        }

        return current.data;
    }

    /**
     * @{inherit}
     */
    override public function iterator():Iterator<T>
    {
        return new Iterator<T>(this);
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        var removed:Bool = false;
        if (!this.isEmpty()) {
            var current:Element<T> = this.anchor.next;
            while (current != this.anchor && current.data != item) {
                current = current.next;
            }

            if (current.data == item) {
                current.prev.next = current.next;
                current.next.prev = current.prev;

                --this.size;
                removed = true;
            }
        }

        return removed;
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
            var current:Element<T>;
            if (index < (this.length / 2)) {
                current = this.anchor.next;
                for (i in 0...index) {
                    current = current.next;
                }
            } else {
                current = this.anchor.prev;
                var limit:Int = this.length - 1;
                for (i in index...limit) {
                    current = current.prev;
                }
            }
            current.data = item;
        }

        return item;
    }
}


/**
 * Wrapper element around stored items.
 */
private class Element<T>
{
    public var next:Element<T>;
    public var prev:Element<T>;
    public var data:T;

    public function new(?data:T):Void
    {
        this.data = data;
    }
}


/**
 * ListIterator optimized for LinkedLists.
 */
class Iterator<T> extends ListIterator<T>
{
    /**
     * Stores the current item.
     *
     * @var lib.ds.LinkedList.Element<T>
     */
    private var current:Element<T>;


    /**
     * Constructor to initialize a new Iterator.
     *
     * @param lib.ds.LinkedList<T> list the LinkedList to iterate over
     */
    @:access(lib.ds.LinkedList.anchor)
    public function new(list:LinkedList<T>):Void
    {
        super(list);
        this.current = list.anchor;
    }

    /**
     * @{inherit}
     */
    @:access(lib.ds.LinkedList.anchor)
    override public inline function hasNext():Bool
    {
        return this.current.next != untyped this.list.anchor;
    }

    /**
     * @{inherit}
     */
    override public inline function next():T
    {
        current = current.next;
        return current.data;
    }
}

