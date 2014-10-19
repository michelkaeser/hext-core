package hext.ds;

import hext.Arrayable;
import hext.NotImplementedException;
import hext.Stringable;
import hext.ds.ICollection;

/**
 * Abstract base implementation of the ICollection interface
 * to be extended by concrete ICollection implementations.
 *
 * @abstract
 *
 * @generic T the type of items the Collection can store
 */
class Collection<T> implements ICollection<T> implements Arrayable<T> implements Stringable
{
    /**
     * @{inherit}
     */
    public var size(default, null):Int;


    /**
     * Constructor to initialize a new Collection.
     */
    private function new():Void
    {
        this.size = 0;
    }

    /**
     * @{inherit}
     */
    public function add(item:T):Bool
    {
        throw new NotImplementedException("Method add() not implemented in abstract class Collection.");
    }

    /**
     * @{inherit}
     */
    public function addAll(items:Iterable<T>):Int
    {
        var counter:Int = 0;
        for (item in items) {
            if (this.add(item)) {
                ++counter;
            }
        }

        return counter;
    }

    /**
     * @{inherit}
     */
    public function clear():Void
    {
        this.size = 0;
    }

    /**
     * @{inherit}
     */
    public function contains(item:T):Bool
    {
        if (!this.isEmpty()) {
            for (stored in this) {
                if (stored == item) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * @{inherit}
     */
    public inline function isEmpty():Bool
    {
        return this.size == 0;
    }

    /**
     * @{inherit}
     */
    public function iterator():Iterator<T>
    {
        throw new NotImplementedException("Method iterator() not implemented in abstract class Collection.");
    }

    /**
     * @{inherit}
     */
    public function remove(item:T):Bool
    {
        throw new NotImplementedException("Method remove() not implemented in abstract class Collection.");
    }

    /**
     * @{inherit}
     */
    public function removeAll(items:Iterable<T>):Int
    {
        var counter:Int = 0;
        for (item in items) {
            if (this.remove(item)) {
                ++counter;
            }
        }

        return counter;
    }

    /**
     * @{inherit}
     */
    public function toArray():Array<T>
    {
        return Lambda.array(this);
    }

    /**
     * @{inherit}
     */
    public function toString():String
    {
        var str:String = "[";
        if (!this.isEmpty()) {
            var buffer:StringBuf = new StringBuf();
            var item:T;
            for (item in this) {
                buffer.add(Std.string(item) + ", ");
            }
            str += buffer.toString();
            str = str.substr(0, str.length - 2);
        }
        str += "]";

        return str;
    }
}
