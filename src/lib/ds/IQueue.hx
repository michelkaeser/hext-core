package lib.ds;

/**
 * The Queue interface defines a set of data-structures that do not
 * require/provide access to single items within the Queue.
 *
 * Items can only be pushed or popped from the Queue - no other operations are supported.
 *
 * @generic T the type of items the Queue can store
 */
interface IQueue<T>
{
    /**
     * Property to access the Queue's length (number of stored items).
     *
     * @var Int
     */
    public var length(get, never):Int;


    /**
     * Checks if the Queue is empty.
     *
     * @return Bool
     */
    public function isEmpty():Bool;

    /**
     * Returns and removes the item on top of the Queue.
     *
     * If the Queue is empty, a lib.ds.NoSuchElementException should be thrown.
     *
     * @return T
     */
    public function pop():T;

    /**
     * Adds the item to the Queue.
     *
     * @param T item the item to add
     *
     * @return Int the new length
     */
    public function push(item:T):Int;

    /**
     * Returns the item on top of the Queue.
     *
     * If the Queue is empty, a lib.ds.NoSuchElementException should be thrown.
     *
     * @return T
     */
    public function top():T;
}
