package lib.threading;

#if (cpp || cs || java || neko)
    import lib.vm.Thread;
#elseif (flash || js)
    import haxe.Timer;
#elseif
    #error "lib.threading.ThreadExecutor is not available on target platform."
#end
import lib.Callback;
import lib.threading.IExecutor;

/**
 * The ThreadExecutor is an Executor implementation that processes
 * each callback within its own thread.
 *
 * It is well-suited for long running operations, but less for frequent executions.
 */
class ThreadExecutor implements IExecutor
{
    /**
     * Constructor to initialize a new ThreadExecutor.
     */
    public function new():Void {}

    /**
     * @{inherit}
     */
    public function execute<T>(callback:Callback<T>, arg:T):Void
    {
        #if (flash || js)
            Timer.delay(function():Void {
                callback(arg);
            }, 0);
        #else
            Thread.create(function():Void {
                callback(arg);
            });
        #end
    }
}
