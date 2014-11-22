package hext.threading;

import haxe.ds.Vector;
import hext.Closure;
import hext.IllegalArgumentException;
import hext.threading.IExecutor;
import hext.vm.Deque;
import hext.vm.IDeque;
import hext.vm.Looper;

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
     * @var Vector<hext.vm.Looper>
     */
    private var executors:Vector<Looper>;

    /**
     * Stores the jobs/callbacks the executors need to process.
     *
     * @var hext.vm.IDeque<hext.Closure>
     */
    private var jobs:IDeque<Closure>;


    /**
     * Constructor to initialize a new PoolExecutor.
     *
     * @param Int pool the number of threads to put into the pool
     *
     * @throws hext.IllegalArgumentException if 'pool' is less than 1
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
                #if HEXT_DEBUG
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
