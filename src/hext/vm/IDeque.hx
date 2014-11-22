package hext.vm;

/**
 * The IDeque interface should be implemented by thread-safe queues that support
 * waiting for an item if the queue is currently empty.
 *
 * @generic T the type of items the queue can store
 */
interface IDeque<T>
{
    /**
     * Adds the item to the start of the queue.
     *
     * @param T item the item to add
     */
    public function add(item:T):Void;

    /**
     * Pops and returns the first item on the IDeque.
     *
     * The item is removed from the IDeque.
     *
     * @param Bool block either to block if the queue is empty or not
     *
     * @returns Null<T> the poped item
     */
    public function pop(block:Bool):Null<T>;

    /**
     * Pushs the item to the end of the queue.
     *
     * @param T item the item to push
     */
    public function push(item:T):Void;
}
