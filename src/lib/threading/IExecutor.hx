package lib.threading;

import lib.Closure;

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
     * Note: If you'd like to execute functions that accept arguments, you can either wrap them inside
     * another function block or "make them parameterless" with function.bind(<params>)
     *
     * @param lib.Closure fn the function to execute
     */
    public function execute(fn:Closure):Void;
}
