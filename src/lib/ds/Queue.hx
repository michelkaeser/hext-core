package lib.ds;

#if (cpp || cs || flash || java || neko)
    import lib.ds.SynchronizedQueue;
#end
import lib.NotImplementedException;
import lib.ds.IQueue;

/**
 * Abstract base implementation of the IQueue interface
 * to be extended by concrete IQueue implementations.
 *
 * @abstract
 *
 * @generic T the type of items the Queue can store
 */
class Queue<T> implements IQueue<T>
{
    /**
     * @{inherit}
     */
    public var length(get, never):Int;


    /**
     * Constructor to initialize a new Queue.
     */
    private function new():Void {}

    /**
     * Internal method used by the length property to return the Queue's length.
     *
     * @return Int
     */
    private function get_length():Int
    {
        throw new NotImplementedException("Method get_length() not implemented in abstract class Queue");
    }

    /**
     * @{inherit}
     */
    public inline function isEmpty():Bool
    {
        return this.length == 0;
    }

    /**
     * @{inherit}
     */
    public function pop():T
    {
        throw new NotImplementedException("Method pop() not implemented in abstract class Queue");
    }

    /**
     * @{inherit}
     */
    public function push(item:T):Int
    {
        throw new NotImplementedException("Method push() not implemented in abstract class Queue");
    }

    /**
     * @{inherit}
     */
    public function top():T
    {
        throw new NotImplementedException("Method top() not implemented in abstract class Queue");
    }
}
