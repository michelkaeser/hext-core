package lib.vm;

#if !(cpp || cs || java || neko)
    #error "lib.vm.NumLock is not available on target platform."
#end

import lib.IllegalArgumentException;
import lib.threading.ISynchronizer;
import lib.threading.Synchronizer;
import lib.vm.ILock;
import lib.vm.Lock;

/**
 * Lock decorator that requires multiple release calls before the Lock gets released.
 *
 * Use cases:
 *   - Waiting for two Threads. Instead of having two regular Locks, one NumLock is enough.
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
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var lib.threading.ISynchronizer
     */
    private var synchronizer:ISynchronizer;

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
            throw new IllegalArgumentException("Number of needed relases cannot be less than 1.");
        }

        this.handle       = lock;
        this.synchronizer = new Synchronizer();
        this.times        = times;
        this.releases     = 0;
    }

    /**
     * @{inherit}
     */
    public function release():Void
    {
        this.synchronizer.sync(function():Void {
            if (++this.releases == this.times) {
                this.handle.release();
                this.releases = 0;
            }
        });
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
