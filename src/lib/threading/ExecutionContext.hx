package lib.threading;

import lib.threading.IExecutor;
#if js
    import lib.threading.ThreadExecutor;
#else
    import lib.threading.PoolExecutor;
#end
import lib.threading.SequentialExecutor;

/**
 * The static only ExecutionContext class provides a single access point
 * for classes requesting access to an Executor instance.
 *
 * This class was introduced to prevent massive Executor initialization.
 *
 * Note: Properties are implemented using (get, set) to support lazy-loading
 * (don't create an Executor if the dev will set one by hand).
 *
 * Use cases:
 *   - Implementing an eco-system where a lot lib.Callbacks are executed by lib.threading.IExecutors.
 *     Instead of passing executors each time, the implementation might get its default Executor from here.
 */
class ExecutionContext
{
    /**
     * Propery holding the default Executor (for sequential operations).
     *
     * @var lib.threading.IExecutor
     */
    @:isVar public static var defaultExecutor(get, set):IExecutor;

    /**
     * Propery holding the default Executor for parallel operations.
     *
     * @var lib.threading.IExecutor
     */
    @:isVar public static var parallelExecutor(get, set):IExecutor;

    /**
     * Propery holding a reference to the prefered Executor instance.
     *
     * @var lib.threading.IExecutor
     */
    public static var preferedExecutor:IExecutor = ExecutionContext.parallelExecutor;


    /**
     * Internal getter method for the defaultExecutor property.
     *
     * @return lib.threading.IExecutor
     */
    private static function get_defaultExecutor():IExecutor
    {
        if (ExecutionContext.defaultExecutor == null) {
            ExecutionContext.defaultExecutor = new SequentialExecutor();
        }

        return ExecutionContext.defaultExecutor;
    }

    /**
     * Internal getter method for the parallelExecutor property.
     *
     * @return lib.threading.IExecutor
     */
    private static function get_parallelExecutor():IExecutor
    {
        if (ExecutionContext.parallelExecutor == null) {
            ExecutionContext.parallelExecutor = #if js new ThreadExecutor(); #else new PoolExecutor(4); #end
        }

        return ExecutionContext.parallelExecutor;
    }

    /**
     * Internal setter method for the defaultExecutor property.
     *
     * @param lib.threading.IExecutor executor the Executor to set
     *
     * @return lib.threading.IExecutor
     */
    private static function set_defaultExecutor(executor:IExecutor):IExecutor
    {
        return ExecutionContext.defaultExecutor = executor;
    }

    /**
     * Internal setter method for the parallelExecutor property.
     *
     * @param lib.threading.IExecutor executor the Executor to set
     *
     * @return lib.threading.IExecutor
     */
    private static function set_parallelExecutor(executor:IExecutor):IExecutor
    {
        return ExecutionContext.parallelExecutor = executor;
    }
}
