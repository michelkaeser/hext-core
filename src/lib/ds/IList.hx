package lib.ds;

import lib.ds.ICollection;

/**
 * Public API interface for List data-structures.
 *
 * Lists should be used when random/Array access is not required as searching and
 * accessing items may not be fast.
 *
 * @generic T the type of items the List can store
 */
interface IList<T> extends ICollection<T>
{
    /**
     * Property to access the List's length (number of stored items).
     *
     * @var Int
     */
    public var length(get, never):Int;


    /**
     * Deletes the item at the given index.
     *
     * If the index is greater than the List's length,
     * a lib.ds.IndexOutOfBoundsException should be thrown.
     *
     * @param Int index the index to delete
     */
    public function delete(index:Int):Void;

    /**
     * Returns the item at the given index.
     *
     * If the index is invalid (out of range, negative),
     * a lib.ds.IndexOutOfBoundsException or lib.ds.NoSuchElementException should be thrown.
     *
     * @return T
     */
    public function get(index:Int):T;

    /**
     * Returns the index of the given item.
     *
     * If the element does not exist, -1 should be returned.
     *
     * @param T item the item to get the index for
     *
     * @return Int
     */
    public function indexOf(item:T):Int;

    /**
     * Returns all indexes of the given item in the List.
     *
     * @param T item the item to get the indexes for
     *
     * @return Array<Int>
     */
    public function indexesOf(item:T):Array<Int>;

    /**
     * Returns the last index of the given item.
     *
     * If the item does not exist, -1 should be returned.
     *
     * @param T item the item to get the index for
     *
     * @return Int
     */
    public function lastIndexOf(item:T):Int;

    /**
     * Sets the value at the given index to the item provided.
     *
     * If the index is invalid (out of range, negative),
     * a lib.ds.IndexOutOfBoundsException or lib.ds.NoSuchElementException should be thrown.
     *
     * @param Int index the index to set the value for
     * @param T   item  the item to set at the index
     *
     * @return T the new item at the given index
     */
    public function set(index:Int, item:T):T;

    /**
     * Returns a Sublist of starting at index 'start' to 'end' of the List.
     *
     * @param Int start the start index
     * @param Int end   the end index (excluded)
     *
     * @return lib.ds.IList<T>
     */
    public function subList(start:Int, end:Int):IList<T>;
}
