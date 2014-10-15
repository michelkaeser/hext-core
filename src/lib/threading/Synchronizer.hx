package lib.threading;

#if !(cpp || cs || java || neko)
    #error "lib.threading.Synchronizer is not available on target platform."
#end

import lib.Closure;
import lib.threading.ISynchronizer;
import lib.vm.IMutex;
import lib.vm.Mutex;

/**
 * Standard Synchronizer implmenetation using Mutexes.
 *
 * Use cases:
 *   - Synchronize various code blocks within your application/class. Instead of managing your
 *     own mutex, you simply call to-be-synchronized calls through the Synchronizer.
 */
class Synchronizer implements ISynchronizer
{
    /**
     * Stores the Mutex used to ensure only one Thread a time is executing the sync
     * function.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;


    /**
     * Constructor to initialize a new Synchronizer.
     */
    public function new():Void
    {
        this.mutex = new Mutex();
    }

    /**
     * @{inherit}
     */
    public function sync(fn:Closure):Void
    {
        this.mutex.acquire();
        try {
            fn();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();
    }
}
