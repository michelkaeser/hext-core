package hext.threading;

import hext.threading.IExecutor;
#if js
    import hext.threading.ThreadExecutor;
#else
    import hext.threading.PoolExecutor;
#end
import hext.threading.SequentialExecutor;

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
 *   - Implementing an eco-system where a lot hext.Callbacks are executed by hext.threading.IExecutors.
 *     Instead of passing executors each time, the implementation might get its default Executor from here.
 */
class ExecutionContext
{
    /**
     * Propery holding the default Executor (for sequential operations).
     *
     * @var Null<hext.threading.IExecutor>
     */
    @:isVar public static var defaultExecutor(get, set):Null<IExecutor>;

    /**
     * Propery holding the default Executor for parallel operations.
     *
     * @var Null<hext.threading.IExecutor>
     */
    @:isVar public static var parallelExecutor(get, set):Null<IExecutor>;

    /**
     * Propery holding a reference to the prefered Executor instance.
     *
     * @var Null<hext.threading.IExecutor>
     */
    @:isVar public static var preferedExecutor(get, set):Null<IExecutor>;


    /**
     * Internal getter method for the defaultExecutor property.
     *
     * @return hext.threading.IExecutor
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
     * @return hext.threading.IExecutor
     */
    private static function get_parallelExecutor():IExecutor
    {
        if (ExecutionContext.parallelExecutor == null) {
            // TODO: set the number of Threads in PoolExecutor in relation to number of cores
            ExecutionContext.parallelExecutor = #if js new ThreadExecutor(); #else new PoolExecutor(100); #end
        }

        return ExecutionContext.parallelExecutor;
    }

    /**
     * Internal getter method for the preferedExecutor property.
     *
     * @return hext.threading.IExecutor
     */
    private static function get_preferedExecutor():IExecutor
    {
        if (ExecutionContext.preferedExecutor == null) {
            ExecutionContext.preferedExecutor = ExecutionContext.parallelExecutor;
        }

        return ExecutionContext.preferedExecutor;
    }

    /**
     * Internal setter method for the defaultExecutor property.
     *
     * @param hext.threading.IExecutor executor the Executor to set
     *
     * @return hext.threading.IExecutor
     */
    private static function set_defaultExecutor(executor:IExecutor):IExecutor
    {
        return ExecutionContext.defaultExecutor = executor;
    }

    /**
     * Internal setter method for the parallelExecutor property.
     *
     * @param hext.threading.IExecutor executor the Executor to set
     *
     * @return hext.threading.IExecutor
     */
    private static function set_parallelExecutor(executor:IExecutor):IExecutor
    {
        return ExecutionContext.parallelExecutor = executor;
    }

    /**
     * Internal setter method for the preferedExecutor property.
     *
     * @param hext.threading.IExecutor executor the Executor to set
     *
     * @return hext.threading.IExecutor
     */
    private static function set_preferedExecutor(executor:IExecutor):IExecutor
    {
        return ExecutionContext.preferedExecutor = executor;
    }
}
