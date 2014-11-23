package hext.cs.haxe;

#if !cs
    #error "hext.cs.haxe.Deque is only available on C# target."
#end

import haxe.Serializer;
import haxe.Unserializer;
import hext.ICloneable;
import hext.ISerializable;
import hext.threading.ds.SynchronizedList;
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
     * Stores the List to store the items.
     *
     * @var hext.threading.ds.SynchronizedList<T>
     */
    @:final private var list:SynchronizedList<T>;

    /**
     * Stores the Lock used to block pop(true) calls.
     *
     * @var hext.vm.ILock
     */
    @:final private var lock:ILock;

    /**
     * Stores the Mutex used to synchronize access to pop() and length checks.
     *
     * @var hext.vm.Mutex
     */
    @:final private var mutex:Mutex;


    /**
     * Constructor to initialize a new Deque.
     */
    public function new():Void
    {
        this.list  = new SynchronizedList<T>();
        this.lock  = new Lock();
        this.mutex = new Mutex();
    }

    /**
     * Adds the item at the end of the Deque.
     *
     * @param T item the item to add
     */
    public function add(item:T):Void
    {
        // need to keep an eye on that. may need try/catch wrapping to ensure mutex is released
        this.mutex.acquire();
        this.list.add(item);
        if (this.list.length == 1) {
            this.lock.release();
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function clone():Deque<T>
    {
        var clone:Deque<T> = new Deque<T>();
        clone.list         = this.list.clone();

        return clone;
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.list);
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.list  = unserializer.unserialize();
        this.lock  = new Lock();
        this.mutex = new Mutex();
    }

    /**
     * Returns the first item in the Deque.
     *
     * If 'block' is false and the Deque is empty, null is returned.
     *
     * @param Bool block if true, wait until an item is available if the Deque is empty
     *
     * @return Null<T>
     */
    public function pop(block:Bool):Null<T>
    {
        // need to keep an eye on that. may need try/catch wrapping to ensure mutex is released
        var top:Null<T> = null;
        this.mutex.acquire();
        if (this.list.isEmpty()) {
            this.mutex.release();
            if (block) {
                while (true) {
                    this.lock.wait(0.01);
                    this.mutex.acquire();
                    if (!this.list.isEmpty()) {
                        top = this.list.pop();
                        this.mutex.release();
                        break;
                    } else {
                        this.mutex.release();
                    }
                }
            }
        } else {
            top = this.list.pop();
            this.mutex.release();
        }

        return top;
    }

    /**
     * Adds the item at the beginning of the Deque.
     *
     * @param T item the item to add
     */
    public function push(item:T):Void
    {
        // need to keep an eye on that. may need try/catch wrapping to ensure mutex is released
        this.mutex.acquire();
        this.list.push(item);
        if (this.list.length == 1) {
            this.lock.release();
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function toString():String
    {
        return this.list.toString();
    }
}
