package lib;

/**
 * The Arrayable interface forces the implementing class
 * to offer a public API method to get an Array representative of the instance.
 *
 * Attn: If manipulating Array items leads to wrong states (e.g. in lib.ds.SortedSet),
 * a copy (also of the items if reference values) should be returned rather than the original Array.
 *
 * @generic T the type of items the Array will contain
 */
interface Arrayable<T>
{
    /**
     * Returns an Array representing the instance.
     *
     * For classes using internal properties to store states, only the real
     * data should be included in the Array. For example Collections
     * only include the items, but not the size etc.
     *
     * @return Array<T>
     */
    public function toArray():Array<T>;
}
