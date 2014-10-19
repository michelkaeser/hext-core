package hext.threading;

import hext.Callback;
import hext.Closure;
import hext.threading.ExecutionContext;
import hext.threading.IExecutor;
import hext.vm.Lock;
import hext.vm.NumLock;

/**
 * Parallel processing class inspired by Microsoft's .NET Parallel class.
 *
 * The class provides various method to run operations/loops in parallel without blocking
 * the calling Thread.
 *
 * Attn: If you call the iteration methods within a recursive function, make sure to use
 * a hext.threading.ThreadExecutor, as other Executors will result in deadlocks.
 *
 * Note: The 'executor' property is implemented with (get, set) to support lazy-loading
 * (don't create an Executor if the dev will set one by hand).
 *
 * Use cases:
 *   - You want parallism but do not want to care about synchronization.
 */
class Parallel
{
    /**
     * Property holding the Executor that will process the tasks/callbacks.
     *
     * @var hext.threading.IExecutor
     */
    @:isVar public static var executor(get, set):IExecutor;


    /**
     * Executes the callback function for each value in 'it' (in parallel).
     *
     * @param Iterable<T>      it the iterable for which values the callback is executed
     * @param hext.Callback<T> fn the callback function to execute
     */
    public static function forEach<T>(it:Iterable<T>, fn:Callback<T>):Void
    {
        if (!Lambda.empty(it)) {
            var lock:NumLock = new NumLock(new Lock(), Lambda.count(it));
            for (item in it) {
                Parallel.executor.execute(function(fn:Callback<T>, arg:T):Void {
                    try {
                        fn(arg);
                    } catch (ex:Dynamic) {
                        lock.release();
                        throw ex;
                    }
                    lock.release();
                }.bind(fn, item));
            }
            lock.wait();
        }
    }

    /**
     * Executes the callback function for each value in the range between 'start' and 'end'
     *
     * @param T:Int                start the range's start value
     * @param T:Int                end   the range's end value
     * @param hext.Callback<T:Int> fn    the callback function to execute
     */
    public static function forRange<T:Int>(start:T, end:T, fn:Callback<T>):Void
    {
        if (end > start) {
            var lock:NumLock = new NumLock(new Lock(), end - start);
            for (i in start...end) {
                Parallel.executor.execute(function(fn:Callback<T>, arg:T):Void {
                    try {
                        fn(arg);
                    } catch (ex:Dynamic) {
                        lock.release();
                        throw ex;
                    }
                    lock.release();
                }.bind(fn, cast i));
            }
            lock.wait();
        }
    }

    /**
     * Internal getter method for the executor property.
     *
     * @return hext.threading.IExecutor
     */
    private static function get_executor():IExecutor
    {
        if (Parallel.executor == null) {
            Parallel.executor = ExecutionContext.parallelExecutor;
        }

        return Parallel.executor;
    }

    /**
     * Executes all the functions in parallel.
     *
     * @param Iterable<hext.Closure> fns the functions to execute
     */
    public static function invoke(fns:Iterable<Closure>):Void
    {
        if (!Lambda.empty(fns)) {
            var lock:NumLock = new NumLock(new Lock(), Lambda.count(fns));
            for (fn in fns) {
                Parallel.executor.execute(function(fn:Closure):Void {
                    try {
                        fn();
                    } catch (ex:Dynamic) {
                        lock.release();
                        throw ex;
                    }
                    lock.release();
                }.bind(fn));
            }
            lock.wait();
        }
    }

    /**
     * Internal setter method for the executor property.
     *
     * @param hext.threading.IExecutor executor the Executor to set
     *
     * @return hext.threading.IExecutor
     */
    private static function set_executor(executor:IExecutor):IExecutor
    {
        return Parallel.executor = executor;
    }
}
