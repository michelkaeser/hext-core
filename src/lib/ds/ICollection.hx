package lib.ds;

/**
 * The Collection interface defines the methods that concrate classes must implement
 * in order to satisfy the public API defined for a Collection.
 * A Collection is, as it name says, a group/"not container" that allows storing, removing
 * and searching multiple items in it.
 *
 * Beside the fact that Collections allow to store items, they should where possible be
 * optimized for search/sort algorithms and/or be memory efficient by using as less as possible
 * space for its items.
 *
 * If one method does not make sense in context (should not be the case) an exception should be thrown.
 *
 * @generic T the type of items the Collection stores
 */
interface ICollection<T> // implements Iterable<T>
{
    /**
     * Returns the Collection's size.
     *
     * The size of a Collection is determinated by the number of items it contains.
     *
     * @return Int
     */
    public var size(default, null):Int;


    /**
     * Adds the item to the Collection.
     *
     * A standard implementation should put the item at the end of the Collection.
     * If the Collection doesn't allow duplicates and the item is already present,
     *   false should be returned to signalize that the item has not been added.
     *
     * @param T item the item to add
     *
     * @return Bool true if the item has been added
     */
    public function add(item:T):Bool;

    /**
     * Adds all items from the Iterable to the Collection.
     *
     * @param Iterable<T> items the items to add
     *
     * @return Int the number of added items
     */
    public function addAll(items:Iterable<T>):Int;

    /**
     * Resets the Collection by removing all items from it.
     *
     * If the collection contains settable properties, those should not be reset as we
     * can create a new Collection to get a completely empty/default instance.
     */
    public function clear():Void;

    /**
     * Checks if the item is contained in the Collection.
     *
     * A standard implementation should do strict checking when ever possible.
     * If the item to search is invalid, an exception should be thrown rather than just
     *   returning false - so the caller is notified about the bad code.
     *
     * @param T item the item to search in the Collection
     *
     * @return Bool either the item is contained or not
     */
    public function contains(item:T):Bool;

    /**
     * Checks if the Collection is empty.
     *
     * A Collection is empty by default if no items have been added yet.
     *
     * @return Bool
     */
    public function isEmpty():Bool;

    /**
     * Returns an Iterator that allows iterating over all items in the Collection.
     *
     * @return Iterator<T>
     */
    public function iterator():Iterator<T>;

    /**
     * Removes the item from the Collection.
     *
     * A standard implementation should return true if the item has been removed.
     * A standard implementation should return false if the item is not contained in the
     *   Collection and thus nothing is removed. An exception could be thrown as well,
     *   but we try to only throw exceptions when we have no other value we
     *   can return (e.g. because false is a valid return value).
     * A standard implementation should remove ALL copies/occurs of the item in the Collection.
     * If the argument is invalid an exception should be thrown rather
     *   than simply returning false.
     *
     * @param T item the item to remove from the Collection
     *
     * @return Bool either the item has been removed or not
     */
    public function remove(item:T):Bool;

    /**
     * Removes all items from the Iterable from the Collection.
     *
     * @param Iterable<T> items the items to remove
     *
     * @return Int the number of removed items
     */
    public function removeAll(items:Iterable<T>):Int;
}
