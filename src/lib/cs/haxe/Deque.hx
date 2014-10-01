package lib.cs.haxe;

#if !cs
    #error "lib.cs.haxe.Deque is only available on C# target."
#end

import lib.ds.SynchronizedQueue;
import lib.ds.WaitList;
import lib.vm.IDeque;
import lib.vm.ILock;
import lib.vm.Lock;
import lib.vm.IMutex;
import lib.vm.Mutex;

/**
 * Blocking Deque implementaton for the C# target.
 *
 * See the Deque documentation of C++/Java or Neko to get an idea of what is does.
 *
 * @generic T the type of items the Deque can store
 */
class Deque<T> implements IDeque<T>
{
    /**
     * Stores the Lock used to block pop(true) calls.
     *
     * @var lib.vm.ILock
     */
    private var lock:ILock;

    /**
     * Stores the Mutex used to synchronize access to pop() and isEmpty checks.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;

    /**
     * Stores the queue to store the items.
     *
     * @var lib.ds.SynchronizedQueue<T>
     */
    private var queue:SynchronizedQueue<T>;


    /**
     * Constructor to initialize a new Deque.
     */
    public function new():Void
    {
        this.lock  = new Lock();
        this.mutex = new Mutex();
        this.queue = new SynchronizedQueue<T>(new WaitList<T>());
    }

    /**
     * Adds the item to the end of the queue.
     *
     * @param T item the item to add
     */
    public function add(item:T):Void
    {
        this.mutex.acquire();
        this.queue.push(item);
        if (this.queue.length == 1) {
            this.lock.release();
        }
        this.mutex.release();
    }

    /**
     * Returns the first item in the queue.
     *
     * If 'block' is false and the Deque is empty, null is returned.
     *
     * @param Bool block if true, wait until an item is available if the queue is empty
     *
     * @return Null<T>
     *
     * @throws Dynamic exceptions thrown by the underlaying queue
     */
    public function pop(block:Bool):Null<T>
    {
        var top:T = null;
        if (block) {
            this.mutex.acquire();
            if (this.queue.isEmpty()) {
                this.mutex.release();
                while (true) {
                    this.lock.wait(0.01);
                    this.mutex.acquire();
                    if (!this.queue.isEmpty()) {
                        try {
                            top = this.queue.pop();
                            this.mutex.release();
                            break;
                        } catch (ex:Dynamic) {
                            this.mutex.release();
                            throw ex;
                        }
                    }
                }
            } else {
                top = this.queue.pop();
                this.mutex.release();
            }
        }

        return top;
    }

    /**
     * @see lib.vm.Deque.add()
     */
    public function push(item:T):Void
    {
        this.add(item);
    }
}
