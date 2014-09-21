package lib.threading;

import lib.Callback;

/**
 * The Executor interface can be used to realize an (asynchronous)
 * function/callback handler that processed the argument passed
 * to the execute() function (without blocking the caller).
 *
 * @see https://github.com/andyli/hxAnonCls for a nice way to init anonymous executors
 */
interface IExecutor
{
    /**
     * Executes the provided callback with the given argument.
     *
     * @param lib.Callback<T> callback the callback to execute
     * @param T               arg      the argument to pass to the callback
     *
     * @generic T the type of argument(s) the callback accepts
     */
    public function execute<T>(callback:Callback<T>, arg:T):Void;
}
