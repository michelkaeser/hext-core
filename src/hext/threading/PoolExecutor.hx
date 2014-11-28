package hext.threading;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.ds.Vector;
import hext.Closure;
import hext.ICloneable;
import hext.IllegalArgumentException;
import hext.ISerializable;
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
implements ICloneable<PoolExecutor> implements ISerializable
{
    /**
     * Stores the executor threads that will handle the jobs.
     *
     * @var Vector<hext.vm.Looper>
     */
    @:final private var executors:Vector<Looper>;

    /**
     * Stores the jobs/callbacks the executors need to process.
     *
     * @var hext.vm.IDeque<hext.Closure>
     */
    @:final private var jobs:IDeque<Closure>;

    /**
     * Property to access the size of the thread pool.
     *
     * @var Int
     */
    public var size(get, never):Int;


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
     * @{inherit}
     */
    public function clone():PoolExecutor
    {
        return new PoolExecutor(this.executors.length);
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.executors.length);
        serializer.serialize(this.jobs);
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.executors = new Vector<Looper>(unserializer.unserialize());
        this.jobs      = unserializer.unserialize();
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

    /**
     * Internal getter method for the 'size' property.
     *
     * @return Int
     */
    private function get_size():Int
    {
        return this.executors.length;
    }
}
