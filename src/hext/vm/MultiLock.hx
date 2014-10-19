package hext.vm;

import hext.ds.LinkedList;
import hext.ds.SynchronizedList;
import hext.vm.ILock;
import hext.vm.Lock;
import hext.vm.Thread;

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
     * Stores the list of Threads having called wait().
     *
     * @var hext.ds.SynchronizedList<hext.vm.Thread>
     */
    private var waiters:SynchronizedList<Thread>;


    /**
     * Constructor to initialize a new MultiLock instance.
     */
    public function new():Void
    {
        super();
        this.waiters = new SynchronizedList<Thread>(new LinkedList<Thread>());
    }

    /**
     * @{inherit}
     */
    override public function release():Void
    {
        var waiter:Thread;
        for (waiter in this.waiters.toArray()) { // toArray so we don't iterate over the original structure (as we remove items from it)
            this.waiters.remove(waiter);
            super.release();
        }
    }

    /**
     * @{inherit}
     */
    override public function wait(?timeout:Float = -1.0):Bool
    {
        var thread:Thread = Thread.current();
        this.waiters.add(thread);
        #if (java || neko)
            if (timeout == -1.0) {
                timeout = null;
            }
        #end
        var ret:Bool = super.wait(timeout);
        this.waiters.remove(thread);

        return ret;
    }
}
