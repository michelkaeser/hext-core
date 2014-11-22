package hext.cs.system.threading;

#if !cs
    #error "hext.cs.system.threading.SemaphoreSlim is only available on C# target"
#end

import haxe.Int32;

/**
 * A lightweight alternative to Semaphore that limits the number of threads that can access a resource or pool of resources concurrently.
 *
 * @link http://msdn.microsoft.com/en-gb/library/system.threading.semaphoreslim(v=vs.110).aspx
 */
@:native('System.Threading.SemaphoreSlim') extern class SemaphoreSlim
{
    /**
     * Initializes a new instance of the SemaphoreSlim class, specifying the initial and maximum number of requests that can be granted concurrently.
     *
     * @link http://msdn.microsoft.com/en-gb/library/dd270891(v=vs.110).aspx
     *
     * @param haxe.Int32 initialCount the initial number of requests for the semaphore that can be granted concurrently
     * @param haxe.Int32 maximumCount the maximum number of requests for the semaphore that can be granted concurrently
     */
    public function new(initialCount:Int32, maximumCount:Int32):Void;

    /**
     * Exits the SemaphoreSlim once.
     *
     * @link http://msdn.microsoft.com/en-gb/library/dd235727(v=vs.110).aspx
     *
     * @return Int
     */
    public function Release():Int;

    /**
     * Blocks the current thread until it can enter the SemaphoreSlim, using a 32-bit signed integer that specifies the timeout.
     *
     * @link http://msdn.microsoft.com/en-gb/library/dd289488(v=vs.110).aspx
     *
     * @param timeout haxe.Int32 the number of milliseconds to wait, or Timeout.Infinite (-1) to wait indefinitely
     *
     * @return Bool
     */
    public function Wait(timeout:Int32):Bool;
}
