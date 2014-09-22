package lib.vm;

import lib.IllegalArgumentException;
import lib.vm.ILock;
import lib.vm.IMutex;
import lib.vm.Lock;
import lib.vm.Mutex;

/**
 * Lock decorator that requires multiple release calls before the Lock gets released.
 */
class NumLock implements ILock
{
    /**
     * Stores the decorated Lock.
     *
     * @var lib.vm.ILock
     */
    private var handle:ILock;

    /**
     * Mutex used to synchronize access to the times property.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;

    /**
     * Stores the number of times the Lock needs to be released.
     *
     * @var Int
     */
    private var times:Int;

    /**
     * Stores the number of releases.
     *
     * @var Int
     */
    private var releases:Int;


    /**
     * Constructor to initialize a new NumLock.
     *
     * @param lib.vm.ILock lock  the Lock to decorate
     * @param Int          times the num of required released
     *
     * @throws lib.util.IllegalArgumentException if 'times' is less than 1
     */
    public function new(lock:ILock, times:Int):Void
    {
        if (times <= 0) {
            throw new IllegalArgumentException("Number of needed relases cannot be less than 1");
        }

        this.handle   = lock;
        this.mutex    = new Mutex();
        this.times    = times;
        this.releases = 0;
    }

    /**
     * @{inherit}
     */
    public function release():Void
    {
        this.mutex.acquire();
        if (++this.releases == this.times) {
            this.handle.release();
            this.releases = 0;
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function wait(?timeout:Float = -1.0):Bool
    {
        #if (java || neko)
            if (timeout == -1.0) {
                timeout = null;
            }
        #end

        return this.handle.wait(timeout);
    }
}
