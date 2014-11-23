package hext.vm;

import hext.threading.ds.SynchronizedList;
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
     * @var hext.threading.ds.SynchronizedList<hext.vm.Thread>
     */
    @:final private var waiters:SynchronizedList<Thread>;


    /**
     * Constructor to initialize a new MultiLock instance.
     */
    public function new():Void
    {
        super();
        this.waiters = new SynchronizedList<Thread>();
    }

    /**
     * @{inherit}
     */
    override public function clone():MultiLock
    {
        return new MultiLock();
    }

    /**
     * @{inherit}
     */
    override public function release():Void
    {
        for (waiter in Lambda.list(this.waiters)) { // waiter = Thread; make sure we iterate over a copy (as we remove items from it)
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
        var ret:Bool = super.wait(timeout);
        this.waiters.remove(thread);

        return ret;
    }
}
