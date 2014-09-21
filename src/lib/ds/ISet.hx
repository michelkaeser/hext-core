package lib.ds;

import lib.ds.ICollection;

/**
 * The Set interface defines a data-structure that does not allow duplicate items.
 *
 * Beside its responsibility to ensure items are not stored duplicate, Sets are often used
 * when items need to be stored sorted.
 *
 * @generic T the type of items the Set can store
 */
interface ISet<T> extends ICollection<T>
{
    /**
     * Returns a Subset starting at index 'start' to 'end' of the Set.
     *
     * @param Int start the start index
     * @param Int end   the end index (excluded)
     *
     * @return lib.ds.ISet<T>
     */
    public function subSet(start:T, end:T):ISet<T>;
}
