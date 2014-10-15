package lib.ds;

import lib.ds.ISet;
import lib.ds.SynchronizedCollection;

/**
 * TODO
 */
class SynchronizedSet<T> extends SynchronizedCollection<T> implements ISet<T>
{
    /**
     * Constructor to initialize a new SynchronizedSet.
     *
     * @param lib.ds.ISet<T> set the Set to synchronize
     */
    public function new(set:ISet<T>):Void
    {
        super(set);
    }

    /**
     * @{inherit}
     */
    public function subSet(start:T, end:T):SynchronizedSet<T>
    {
        var result:ISet<T>;
        this.synchronizer.sync(function():Void {
            result = cast(this.collection).subSet(start, end);
        });

        return new SynchronizedSet<T>(result);
    }
}
