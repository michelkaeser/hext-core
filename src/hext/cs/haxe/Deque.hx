package hext.cs.haxe;

#if !cs
    #error "hext.cs.haxe.Deque is only available on C# target."
#end

import haxe.Serializer;
import haxe.Unserializer;
import hext.ICloneable;
import hext.ISerializable;
import hext.UnsupportedOperationException;
import hext.ds.SynchronizedQueue;
import hext.ds.WaitList;
import hext.vm.IDeque;
import hext.vm.ILock;
import hext.vm.Lock;
import hext.vm.Mutex;

/**
 * Blocking Deque implementaton for the C# target.
 *
 * See the Deque documentation of C++/Java or Neko to get an idea of what is does.
 *
 * @generic T the type of items the Deque can store
 */
class Deque<T> implements IDeque<T>
implements ICloneable<Deque<T>> implements ISerializable
{
    /**
     * Stores the Lock used to block pop(true) calls.
     *
     * @var hext.vm.ILock
     */
    private var lock:ILock;

    /**
     * Stores the Mutex used to synchronize access to pop() and isEmpty checks.
     *
     * @var hext.vm.Mutex
     */
    private var mutex:Mutex;

    /**
     * Stores the queue to store the items.
     *
     * @var hext.ds.SynchronizedQueue<T>
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
     * @{inherit}
     */
    public function clone():Deque<T>
    {
        throw new UnsupportedOperationException("hext.cs.haxe.Deque instances cannot be cloned.");
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        throw new UnsupportedOperationException("hext.cs.haxe.Deque instances cannot be serialized.");
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        throw new UnsupportedOperationException("hext.cs.haxe.Deque instances cannot be unserialized.");
    }

    /**
     * Returns the first item in the queue.
     *
     * If 'block' is false and the Deque is empty, null is returned.
     *
     * @param Bool block if true, wait until an item is available if the queue is empty
     *
     * @return Null<T>
     */
    public function pop(block:Bool):Null<T>
    {
        var top:T = null;
        this.mutex.acquire();
        if (this.queue.isEmpty()) {
            this.mutex.release();
            if (block) {
                while (true) {
                    this.lock.wait(0.01);
                    this.mutex.acquire();
                    if (!this.queue.isEmpty()) {
                        top = this.queue.pop();
                        this.mutex.release();
                        break;
                    } else {
                        this.mutex.release();
                    }
                }
            }
        } else {
            top = this.queue.pop();
            this.mutex.release();
        }

        return top;
    }

    /**
     * @see hext.vm.Deque.add()
     */
    public inline function push(item:T):Void
    {
        this.add(item);
    }
}
