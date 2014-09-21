package lib.cs.system.threading;

#if !cs
    #error "lib.cs.system.threading.Semaphore is only available on C# target"
#end

import haxe.Int32;

/**
 * Limits the number of threads that can access a resource or pool of resources concurrently.
 *
 * @link http://msdn.microsoft.com/en-us/library/system.threading.semaphore(v=vs.110).aspx
 */
@:native('System.Threading.Semaphore') extern class Semaphore
{
    /**
     * Initializes a new instance of the Semaphore class, specifying the maximum number of concurrent entries and optionally reserving some entries.
     *
     * @link http://msdn.microsoft.com/en-us/library/e1hct27h(v=vs.110).aspx
     *
     * @param haxe.Int32 initialCount the initial number of requests for the semaphore that can be granted concurrently
     * @param haxe.Int32 maximumCount the maximum number of requests for the semaphore that can be granted concurrently
     */
    public function new(initialCount:Int32, maximumCount:Int32):Void;

    /**
     * Exits the semaphore and returns the previous count.
     *
     * @link http://msdn.microsoft.com/en-us/library/6caa9s64(v=vs.110).aspx
     *
     * @return Int
     */
    public function Release():Int;

    /**
     * Blocks the current thread until the current WaitHandle receives a signal.
     *
     * @link http://msdn.microsoft.com/en-us/library/58195swd(v=vs.110).aspx
     *
     * @param timeout haxe.Int32 the number of milliseconds to wait, or Timeout.Infinite (-1) to wait indefinitely
     *
     * @return Bool
     */
    public function WaitOne(timeout:Int32):Bool;
}
