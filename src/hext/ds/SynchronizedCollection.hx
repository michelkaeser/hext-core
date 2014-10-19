package hext.ds;

import hext.Arrayable;
import hext.NotImplementedException;
import hext.Stringable;
import hext.ds.ICollection;
import hext.threading.ISynchronizer;
import hext.threading.Synchronizer;

/**
 * TODO
 */
class SynchronizedCollection<T> implements ICollection<T> implements Arrayable<T> implements Stringable
{
    /**
     * Stores the underlaying Collection.
     *
     * @var hext.ds.ICollection<T>
     */
    private var collection:ICollection<T>;

    /**
     * TODO: get, never is required...
     */
    public var size(default, null):Int;

    /**
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var hext.threading.ISynchronizer
     */
    private var synchronizer:ISynchronizer;


    /**
     * Constructor to initialize a new SynchronizedCollection.
     *
     * @param hext.ds.ICollection<T> collection the Collection to synchronize
     */
    private function new(collection:ICollection<T>):Void
    {
        this.collection   = collection;
        this.synchronizer = new Synchronizer();
    }

    /**
     * @{inherit}
     */
    public function add(item:T):Bool
    {
        var result:Bool;
        this.synchronizer.sync(function():Void {
            result = this.collection.add(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function addAll(items:Iterable<T>):Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = this.collection.addAll(items);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function clear():Void
    {
        this.synchronizer.sync(function():Void {
            this.collection.clear();
        });
    }

    /**
     * @{inherit}
     */
    public function contains(item:T):Bool
    {
        var result:Bool;
        this.synchronizer.sync(function():Void {
            result = this.collection.contains(item);
        });

        return result;
    }

    /**
     * TODO: see size property
     */
    @:noCompletion
    private function get_size():Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = this.collection.size;
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function isEmpty():Bool
    {
        var result:Bool;
        this.synchronizer.sync(function():Void {
            result = this.collection.isEmpty();
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function iterator():Iterator<T>
    {
        throw new NotImplementedException("Method iterator() not implemented in abstract class SynchronizedCollection.");
    }

    /**
     * @{inherit}
     */
    public function remove(item:T):Bool
    {
        var result:Bool;
        this.synchronizer.sync(function():Void {
            result = this.collection.remove(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function removeAll(items:Iterable<T>):Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = this.collection.removeAll(items);
        });

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
        this.synchronizer.sync(function():Void {
            arr = cast(this.collection).toArray();
        });

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
        this.synchronizer.sync(function():Void {
            str = cast(this.collection).toString();
        });

        return str;
    }
}
