package lib.ds;

#if (cpp || cs || flash || java || neko)
    import lib.ds.SynchronizedList;
#end
import lib.IllegalArgumentException;
import lib.NotImplementedException;
import lib.ds.Collection;
import lib.ds.IList;
import lib.ds.IndexOutOfBoundsException;
import lib.ds.ListIterator;

/**
 * Abstract base implementation of the IList interface
 * to be extended by concrete IList implementations.
 *
 * @abstract
 *
 * @generic T the type of items the List can store
 */
class List<T> extends Collection<T> implements IList<T>
{
    /**
     * @{inherit}
     */
    public var length(get, never):Int;


    /**
     * Constructor to initialize a new List.
     */
    private function new():Void
    {
        super();
    }

    /**
     * @{inherit}
     */
    public function delete(index:Int):Void
    {
        throw new NotImplementedException("Method delete() not implemented in abstract class List");
    }

    /**
     * @{inherit}
     */
    public function get(index:Int):T
    {
        throw new NotImplementedException("Method get() not implemented in abstract class List");
    }

    /**
     * @{inherit}
     */
    private #if LIB_INLINE inline #end function get_length():Int
    {
        return this.size;
    }

    /**
     * @{inherit}
     */
    public function indexOf(item:T):Int
    {
        if (!this.isEmpty()) {
            var counter:Int = 0;
            for (stored in this) {
                if (item == stored) {
                    return counter;
                }
                ++counter;
            }
        }

        return -1;
    }

    /**
     * @{inherit}
     */
    public function indexesOf(item:T):Array<Int>
    {
        var indexes:Array<Int> = new Array<Int>();
        if (!this.isEmpty()) {
            var counter:Int = 0;
            for (stored in this) {
                if (item == stored) {
                    indexes.push(counter);
                }
                ++counter;
            }
        }

        return indexes;
    }

    /**
     * @{inherit}
     */
    override public function iterator():ListIterator<T>
    {
        return new ListIterator<T>(this);
    }

    /**
     * @{inherit}
     */
    public function lastIndexOf(item:T):Int
    {
        var indexes:Array<Int> = this.indexesOf(item);
        if (indexes.length != 0) {
            return indexes[indexes.length - 1];
        }

        return -1;
    }

    /**
     * @{inherit}
     */
    public function set(index:Int, item:T):T
    {
        throw new NotImplementedException("Method set() not implemented in abstract class List");
    }

    /**
     * @{inherit}
     */
    public function subList(start:Int, end:Int):List<T>
    {
        if (end < start) {
            throw new IllegalArgumentException("End index cannot be less than start");
        }

        if (end > this.length) {
            throw new IndexOutOfBoundsException("End index cannot be greater than the List's length");
        }

        var sub:List<T> = Type.createInstance(Type.getClass(this), new Array<Dynamic>());
        if (!this.isEmpty() && start != end) {
            var counter:Int = 0;
            var it:ListIterator<T> = this.iterator();
            var item:T;
            while (counter < end && it.hasNext()) {
                item = it.next();
                if (counter >= start) {
                    sub.add(item);
                }
                ++counter;
            }
        }

        return sub;
    }

    /**
     * @{inherit}
     */
    // overwritten to include the index
    override public function toString():String
    {
        var str:String = "[";
        if (!this.isEmpty()) {
            var buffer:StringBuf = new StringBuf();
            var item:T;
            var index:Int = 0;
            for (item in this) {
                buffer.add(Std.string(index) + ": " + Std.string(item) + ", ");
                ++index;
            }
            str += buffer.toString();
            str = str.substr(0, str.length - 2);
        }
        str += "]";

        return str;
    }
}
