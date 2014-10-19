package hext.threading;

#if (cpp || cs || java || neko)
    import hext.vm.Thread;
#elseif (flash || js)
    import haxe.Timer;
#elseif
    #error "hext.threading.ThreadExecutor is not available on target platform."
#end
import hext.Closure;
import hext.threading.IExecutor;

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
    public function execute(fn:Closure):Void
    {
        #if (flash || js)
            Timer.delay(fn, 0);
        #else
            Thread.create(fn);
        #end
    }
}
