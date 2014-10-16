package lib.threading;

import lib.Closure;
import lib.NotImplementedException;
import lib.threading.IExecutor;

/**
 * Sequential Executor to be used as a fallback for situations
 * where an Executor is required but we do not want an async one.
 */
class SequentialExecutor implements IExecutor
{
    /**
     * Constructor to initialize a new Sequential Executor.
     */
    public function new():Void {}

    /**
     * @{inherit}
     */
    public function execute(fn:Closure):Void
    {
        fn();
    }
}
