package lib.ds;

import lib.ds.IList;
import lib.ds.SynchronizedCollection;

/**
 *
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
        this.mutex.acquire();
        try {
            cast(this.collection, IList<Dynamic>).delete(index);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function get(index:Int):T
    {
        var result:T;

        this.mutex.acquire();
        try {
            result = cast(this.collection, IList<Dynamic>).get(index);
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
    @:noCompletion
    private function get_length():Int
    {
        this.mutex.acquire();
        var result:Int = cast(this.collection, IList<Dynamic>).length;
        this.mutex.release();

        return result;
    }

    /**
     * @{inherit}
     */
    public function indexOf(item:T):Int
    {
        var result:Int;

        this.mutex.acquire();
        try {
            result = cast(this.collection, IList<Dynamic>).indexOf(item);
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
    public function indexesOf(item:T):Array<Int>
    {
        var result:Array<Int>;

        this.mutex.acquire();
        try {
            result = cast(this.collection, IList<Dynamic>).indexesOf(item);
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

        this.mutex.acquire();
        try {
            result = cast(this.collection, IList<Dynamic>).lastIndexOf(item);
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
    public function set(index:Int, item:T):T
    {
        var result:T;

        this.mutex.acquire();
        try {
            result = cast(this.collection, IList<Dynamic>).set(index, item);
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
    public function subList(start:Int, end:Int):SynchronizedList<T>
    {
        var result:IList<T>;

        this.mutex.acquire();
        try {
            result = cast(this.collection).subList(start, end);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return new SynchronizedList<T>(result);
    }
}
