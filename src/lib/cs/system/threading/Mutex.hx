package lib.cs.system.threading;

#if !cs
    #error "lib.cs.system.threading.Mutex is only available on C# target"
#end

/**
 * A synchronization primitive that can also be used for interprocess synchronization.
 *
 * @link http://msdn.microsoft.com/en-us/library/System.Threading.Mutex(v=vs.110).aspx
 */
@:native('System.Threading.Mutex') extern class Mutex
{
    /**
     * Initializes a new instance of the Mutex class with default properties.
     *
     * @link http://msdn.microsoft.com/en-us/library/21sa3fy3(v=vs.110).aspx
     */
    public function new():Void;

    /**
     * Releases the Mutex once.
     *
     * @link http://msdn.microsoft.com/en-us/library/system.threading.mutex.releasemutex.aspx
     */
    public function ReleaseMutex():Void;

    /**
     * Blocks the current thread until the current WaitHandle receives a signal.
     *
     * @link http://msdn.microsoft.com/en-us/library/58195swd(v=vs.110).aspx
     */
    public function WaitOne():Void;
}
