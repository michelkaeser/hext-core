package hext.threading.ds;

import hext.threading.ISynchronizer;
import hext.threading.Synchronizer;

/**
 * Synchronized iterator implementation that can be used to make the underlaying
 * iterator implementation thread-safe.
 *
 * @link http://api.haxe.org/Iterator.html
 *
 * @generic T the type of items the Iterator returns
 */
class SynchronizedIterator<T>
{
    /**
     * Stores the Iterator which gets synchronized.
     *
     * @var Iterator<T>
     */
    @:final private var it:Iterator<T>;

    /**
     * Stores the Synchronizer used to sync method access.
     *
     * @var hext.threading.ISynchronizer
     */
    @:final private var synchronizer:ISynchronizer;


    /**
     * Constructor to initialize a new SynchronizedIterator.
     *
     * @param Iterator<T> it the Iterator to synchronize
     */
    public function new(it:Iterator<T>):Void
    {
        this.it           = it;
        this.synchronizer = new Synchronizer();
    }

    /**
     * @link http://api.haxe.org/Iterator.html#hasNext
     */
    public function hasNext():Bool
    {
        var has:Bool;
        this.synchronizer.sync(function():Void {
            has = this.it.hasNext();
        });

        return has;
    }

    /**
     * @link http://api.haxe.org/Iterator.html#next
     */
    public function next():T
    {
        var next:T;
        this.synchronizer.sync(function():Void {
            next = this.it.next();
        });

        return next;
    }
}
