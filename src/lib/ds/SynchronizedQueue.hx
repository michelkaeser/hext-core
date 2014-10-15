package lib.ds;

import lib.ds.IQueue;
import lib.threading.ISynchronizer;
import lib.threading.Synchronizer;

/**
 * TODO
 */
class SynchronizedQueue<T> implements IQueue<T>
{
    /**
     * @{inherit}
     */
    public var length(get, never):Int;

    /**
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var lib.threading.ISynchronizer
     */
    private var synchronizer:ISynchronizer;

    /**
     * Stores the underlaying, to synchronize, Queue.
     *
     * @var lib.ds.IQueue<T>
     */
    private var queue:IQueue<T>;


    /**
     * Constructor to initialize a new SynchronizedQueue.
     *
     * @param lib.ds.IQueue<T> queue the Queue to synchronize
     */
    public function new(queue:IQueue<T>):Void
    {
        this.synchronizer = new Synchronizer();
        this.queue        = queue;
    }

    /**
     * @{inherit}
     */
    @:noCompletion
    private function get_length():Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = this.queue.length;
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
            result = this.queue.isEmpty();
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function pop():T
    {
        var result:T;
        this.synchronizer.sync(function():Void {
            result = this.queue.pop();
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function push(item:T):Int
    {
        var result:Int;
        this.synchronizer.sync(function():Void {
            result = this.queue.push(item);
        });

        return result;
    }

    /**
     * @{inherit}
     */
    public function top():T
    {
        var result:T;
        this.synchronizer.sync(function():Void {
            result = this.queue.top();
        });

        return result;
    }
}
