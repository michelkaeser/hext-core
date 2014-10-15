package lib.threading;

import lib.Closure;

/**
 * The ISynchronizer interface provides the public API for
 * "function executors" (much like lib.threading.IExecutor) that allow only
 * one active function call at a time.
 */
interface ISynchronizer
{
    /**
     * Executes the provided Closure, ensuring no other Thread can execute a function
     * while the currently active one has not finished.
     *
     * @param lib.Closure fn the function to execute
     *
     * @throws Dynamic the exception thrown by the synced function (if any)
     */
    public function sync(fn:Closure):Void;
}
