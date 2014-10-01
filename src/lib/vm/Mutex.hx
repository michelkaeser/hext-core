package lib.vm;

#if !(cpp || cs || flash || java || neko)
    #error "lib.vm.Mutex is not available on target platform."
#end
import lib.vm.IMutex;

/**
 * @{inherit}
 */
class Mutex implements IMutex
{
    /**
     * Stores the underlaying native Mutex.
     *
     * @var lib.vm.Mutex.VMMUtex
     */
    private var handle:VMMutex;

    /**
     * Constructor to initialize a new Lock instance.
     */
    public function new():Void
    {
        this.handle = new VMMutex(#if java 100 #end);
    }

    /**
     * @{inherit}
     */
    public function acquire():Void
    {
        #if cs
            this.handle.WaitOne();
        #elseif flash
            this.handle.lock();
        #elseif java
            try {
                this.handle.acquire();
            } catch (ex:Dynamic) {
                // error: unreported exception InterruptedException; must be caught or declared to be thrown
            }
        #else
            this.handle.acquire();
        #end
    }

    /**
     * Tries to acquire the Mutex.
     *
     * @return Bool true if Mutex got acquired
     */
    #if (cpp || flash || java || neko)
        public function tryAcquire():Bool
        {
            #if flash
                return this.handle.tryLock();
            #else
                return this.handle.tryAcquire();
            #end
        }
    #end

    /**
     * @{inherit}
     */
    public function release():Void
    {
        #if cs
            this.handle.ReleaseMutex();
        #elseif flash
            this.handle.unlock();
        #else
            this.handle.release();
        #end
    }
}


/**
 * Typedef to native VM Mutexes.
 */
private typedef VMMutex =
#if cpp       cpp.vm.Mutex;
#elseif cs    lib.cs.system.threading.Mutex;
#elseif flash flash.concurrent.Mutex;
#elseif java  lib.java.util.concurrent.Semaphore;
#elseif neko  neko.vm.Mutex;
#end
