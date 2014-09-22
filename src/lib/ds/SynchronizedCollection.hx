package lib.ds;

import lib.Arrayable;
import lib.NotImplementedException;
import lib.Stringable;
import lib.ds.ICollection;
import lib.vm.IMutex;
import lib.vm.Mutex;

/**
 *
 */
class SynchronizedCollection<T> implements ICollection<T> implements Arrayable<T> implements Stringable
{
    /**
     * Stores the underlaying Collection.
     *
     * @var lib.ds.ICollection<T>
     */
    private var collection:ICollection<T>;

    /**
     * Stores the Mutex used to synchronize read/write access.
     *
     * @param lib.vm.IMutex
     */
    private var mutex:IMutex;

    /**
     * TODO: get, never is required...
     */
    public var size(default, null):Int;


    /**
     * Constructor to initialize a new SynchronizedCollection.
     *
     * @param lib.ds.ICollection<T> collection the Collection to synchronize
     */
    private function new(collection:ICollection<T>):Void
    {
        this.collection = collection;
        this.mutex      = new Mutex();
    }

    /**
     * @{inherit}
     */
    public function add(item:T):Bool
    {
        var result:Bool;

        this.mutex.acquire();
        try {
            result = this.collection.add(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function addAll(items:Iterable<T>):Int
    {
        var result:Int;

        this.mutex.acquire();
        try {
            result = this.collection.addAll(items);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function clear():Void
    {
        this.mutex.acquire();
        try {
            this.collection.clear();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function contains(item:T):Bool
    {
        var result:Bool;

        this.mutex.acquire();
        try {
            result = this.collection.contains(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * TODO: see size property
     */
    private function get_size():Int
    {
        var result:Int;

        this.mutex.acquire();
        try {
            result = this.collection.size;
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function isEmpty():Bool
    {
        var result:Bool;

        this.mutex.acquire();
        try {
            result = this.collection.isEmpty();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function iterator():Iterator<T>
    {
        throw new NotImplementedException("Method iterator() not implemented in abstract class SynchronizedCollection");
    }

    /**
     * @{inherit}
     */
    public function remove(item:T):Bool
    {
        var result:Bool;

        this.mutex.acquire();
        try {
            result = this.collection.remove(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function removeAll(items:Iterable<T>):Int
    {
        var result:Int;

        this.mutex.acquire();
        try {
            result = this.collection.removeAll(items);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     *
     * TODO: not satisfied by ICollection interface
     */
    public function toArray():Array<T>
    {
        var arr:Array<T>;

        this.mutex.acquire();
        try {
            arr = cast(this.collection).toArray();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return arr;
    }

    /**
     * @{inherit}
     *
     * TODO: not satisfied by ICollection interface
     */
    public function toString():String
    {
        var str:String;

        this.mutex.acquire();
        try {
            str = cast(this.collection).toString();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return str;
    }
}
