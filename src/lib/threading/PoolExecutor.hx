package lib.threading;

import haxe.ds.Vector;
import lib.Closure;
import lib.IllegalArgumentException;
import lib.threading.IExecutor;
import lib.vm.Deque;
import lib.vm.IDeque;
import lib.vm.Looper;

/**
 * The PoolExecutor Executor implementation uses a fixed-size pool of
 * worker/execution threads to process the callbacks passed by execute().
 *
 * This implementation is recommended for applications that "trigger" the
 * execute() method quite often.
 */
class PoolExecutor implements IExecutor
{
    /**
     * Stores the executor threads that will handle the jobs.
     *
     * @var Vector<lib.vm.Looper>
     */
    private var executors:Vector<Looper>;

    /**
     * Stores the jobs/callbacks the executors need to process.
     *
     * @var lib.vm.IDeque<lib.Closure>
     */
    private var jobs:IDeque<Closure>;


    /**
     * Constructor to initialize a new PoolExecutor.
     *
     * @param Int pool the number of threads to put into the pool
     *
     * @throws lib.util.IllegalArgumentException if 'pool' is less than 1
     */
    public function new(pool:Int = 1):Void
    {
        if (pool <= 0) {
            throw new IllegalArgumentException("Number of pool threads cannot be less than 1.");
        }

        this.executors = new Vector<Looper>(pool);
        this.jobs      = new Deque<Closure>();
        this.initialize();
    }

    /**
     * Initializes the executing threads.
     */
    private function initialize():Void
    {
        for (i in 0...this.executors.length) {
            this.executors.set(i, Looper.create(function():Void {
                var fn:Closure = this.jobs.pop(true);
                #if LIB_DEBUG
                    fn();
                #else
                    try {
                        fn();
                    } catch (ex:Dynamic) {}
                #end
            }));
        }
    }

    /**
     * @{inherit}
     */
    public function execute(fn:Closure):Void
    {
        this.jobs.add(fn);
    }
}
