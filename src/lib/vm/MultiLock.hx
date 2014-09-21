package lib.vm;

import lib.vm.ILock;
import lib.vm.IMutex;
import lib.vm.Lock;
import lib.vm.Mutex;
import lib.vm.Thread;

/**
 * A Lock extension that unlocks all waiting Threads rather than just one.
 *
 * This can be useful and a good alternative to a system where one Thread
 * sends a message to all other ones to notify them, that they can continue.
 * That way you do not have to worry about internal signals being sent to
 * the Thread.
 */
class MultiLock extends Lock
{
    /**
     * Stores the Mutex to synchronize access to the waiters Array.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;

    /**
     * Stores the list of Threads having called wait().
     *
     * @var Array<lib.vm.Thread>
     */
    private var waiters:Array<Thread>;


    /**
     * Constructor to initialize a new MultiLock instance.
     */
    public function new():Void
    {
        super();
        this.mutex   = new Mutex();
        this.waiters = new Array<Thread>();
    }

    /**
     * @{inherit}
     */
    override public function release():Void
    {
        var waiter:Thread;
        this.mutex.acquire();
        for (waiter in this.waiters.copy()) {
            this.waiters.remove(waiter);
            super.release();
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    override public function wait(?timeout:Float = -1.0):Bool
    {
        var thread:Thread = Thread.current();

        this.mutex.acquire();
        this.waiters.push(thread);
        this.mutex.release();

        #if (java || neko)
            if (timeout == -1.0) {
                timeout = null;
            }
        #end
        var ret:Bool = super.wait(timeout);

        this.mutex.acquire();
        this.waiters.remove(thread);
        this.mutex.release();

        return ret;
    }
}
