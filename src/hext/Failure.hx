package hext;

import hext.Ref;

/**
 * The Failure type is ment to be used as a reference type to pass to functions
 * so they can return a reference to the item/items that did not met the condition.
 *
 * Use cases:
 *   - As in hext.StringTools.containsAll: Allow the caller to know which item is not included.
 */
typedef Failure<T> =
{
    @:optional var fail:Ref<T>;
    @:optional var fails:List<T>;
};
