package lib.ds;

import lib.ds.IList;
import lib.ds.SynchronizedCollection;

/**
 * TODO
 */
class SynchronizedList<T> extends SynchronizedCollection<T> implements IList<T>
{
    /**
     * @{inherit}
     */
    public var length(get, never):Int;


    /**
     * Constructor to initialize a new SynchronizedList.
     *
     * @param lib.ds.IList<T> list the List to synchronize
     */
    public function new(list:IList<T>):Void
    {
        super(list);
    }

    /**
     * @{inherit}
     */
    public function delete(index:Int):Void
    {
        this.synchronizer.sync(function():Void {
            cast(this.collection, IList<Dynamic>).delete(index);
        });
    }

    /**
     * @{inherit}
     */
    public function get(index:Int):T
    {
        var result:T;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).get(index);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    private function get_length():Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).length;
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function indexOf(item:T):Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).indexOf(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function indexesOf(item:T):Array<Int>
    {
        var result:Array<Int>;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).indexesOf(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    override public function iterator():ListIterator<T>
    {
        return new ListIterator<T>(this);
    }

    /**
     * @{inherit}
     */
    public function lastIndexOf(item:T):Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).lastIndexOf(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function set(index:Int, item:T):T
    {
        var result:T;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection, IList<Dynamic>).set(index, item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function subList(start:Int, end:Int):SynchronizedList<T>
    {
        var result:IList<T>;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection).subList(start, end);
        });

        return new SynchronizedList<T>(result);
    }
}
