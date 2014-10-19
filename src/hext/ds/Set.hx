package hext.ds;

#if (cpp || cs || flash || java || neko)
    import hext.ds.SynchronizedSet;
#end
import hext.IllegalArgumentException;
import hext.ds.Collection;
import hext.ds.ISet;
import hext.util.Comparator;

/**
 * Abstract base implementation of the ISet interface
 * to be extended by concrete ISet implementations.
 *
 * @abstract
 *
 * @generic T the type of items the Set can store
 */
class Set<T> extends Collection<T> implements ISet<T>
{
    /**
     * Stores the Comparator used to compare items for equality.
     *
     * @var hext.util.Comparator<T>
     */
    private var comparator:Comparator<T>;


    /**
     * Constructor to initialize a new Set.
     *
     * @param hext.util.Comparator<T> comparator the Comparator to compare items
     */
    private function new(comparator:Comparator<T>):Void
    {
        super();
        this.comparator = comparator;
    }

    /**
     * @{inherit}
     */
    public function subSet(start:T, end:T):Set<T>
    {
        if (this.comparator(start, end) == 1) {
            throw new IllegalArgumentException("End condition cannot be less than start.");
        }

        var params:Array<Dynamic> = new Array<Dynamic>();
        params.push(Reflect.field(this, "comparator"));
        var sub:Set<T> = Type.createInstance(Type.getClass(this), params);

        if (!this.isEmpty() && this.comparator(start, end) == -1) {
            for (item in this) {
                if (this.comparator(item, start) != -1 && this.comparator(item, end) == -1) {
                    sub.add(item);
                }
            }
        }

        return sub;
    }
}
