package lib.vm;

import lib.Closure;
import lib.IllegalStateException;
import lib.vm.IMutex;
import lib.vm.Mutex;
import lib.vm.Thread;

/**
 * The Looper class extends Threads and execute the callback
 * function multiple times - until the Looper gets destroyed.
 */
class Looper extends Thread
{
    /**
     * Stores the Mutex used to synchronize access to the state.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;

    #if !cs
    /**
     * Stores the Looper's state.
     *
     * @var lib.vm.Looper.State
     */
    private var state:State;
    #end

    /**
     * Constructor to initialize a new Looper instance.
     *
     * @param lib.vm.Thread.VMThread handle the underlaying Thread to wrap
     */
    private function new(handle:VMThread):Void
    {
        super(handle);

        this.mutex = new Mutex();
        #if !cs
            this.state = State.INITIALIZED;
        #end
    }

    /**
     * @{inherit}
     */
    public static inline function current():Looper
    {
        return new Looper(Thread.current().handle);
    }

    /**
     * @{inherit}
     */
    public static function create(fn:Closure):Looper
    {
        var looper:Looper = new Looper(Thread.create(function():Void {
            var self:Looper = Looper.readMessage(true);
            while (!self.isDestroyed()) {
                fn();
            }
            self.handle = null;
        }).handle);
        looper.sendMessage(looper);

        return looper;
    }

    /**
     * Destroys the Looper.
     *
     * The Looper is not destroyed immediately, but when the next loop
     * iteration would be entered.
     */
    public function destroy():Void
    {
        this.mutex.acquire();
        #if cs
            this.handle.Abort();
            this.mutex.release();
        #else
            if (this.state == State.DESTROYED) {
                this.mutex.release();
                throw new IllegalStateException("Cannot destroy an already destroyed Looper.");
            }

            this.state = State.DESTROYED;
            this.mutex.release();
        #end
    }

    /**
     * Checks if the Looper is alive/looping.
     *
     * @return Bool
     */
    public function isAlive():Bool
    {
        return !this.isDestroyed();
    }

    /**
     * Checks if the Looper has been destroyed.
     *
     * @return Bool
     */
    public function isDestroyed():Bool
    {
        this.mutex.acquire();
        #if cs
            var ret:Bool = !this.handle.IsAlive;
        #else
            var ret:Bool = (this.state == State.DESTROYED);
        #end
        this.mutex.release();

        return ret;
    }

    /**
     * @{inherit}
     */
    public static inline function readMessage(block:Bool):Null<Dynamic>
    {
        return Thread.readMessage(block);
    }
}


#if !cs
    /**
     * Enum for the States a Looper can be in.
     */
    private enum State
    {
        DESTROYED;
        INITIALIZED;
        LOOPING;
    }
#end
