package lib.ds;

import lib.ds.IQueue;
import lib.vm.IMutex;
import lib.vm.Mutex;

/**
 *
 */
class SynchronizedQueue<T> implements IQueue<T>
{
    /**
     * @{inherit}
     */
    public var length(get, never):Int;

    /**
     * Stores the Mutex used to synchronize read/write access.
     *
     * @param lib.vm.IMutex
     */
    private var mutex:IMutex;

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
        this.mutex = new Mutex();
        this.queue = queue;
    }

    /**
     * @{inherit}
     */
    private function get_length():Int
    {
        this.mutex.acquire();
        var result:Int = this.queue.length;
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
            result = this.queue.isEmpty();
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
    public function pop():T
    {
        var result:T;

        this.mutex.acquire();
        try {
            result = this.queue.pop();
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
    public function push(item:T):Int
    {
        var result:Int;

        this.mutex.acquire();
        try {
            result = this.queue.push(item);
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
    public function top():T
    {
        var result:T;

        this.mutex.acquire();
        try {
            result = this.queue.top();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return result;
    }
}
