package lib;

import haxe.ds.Vector;

/**
 * Abstract helper that can be used to pass primitive types (Int, Float etc.) by reference.
 *
 * Use cases:
 *   - Storing a function's return code (e.g. 0 == OK, 1 == Failure) inside a passed argument.
 *     This can be helpful if the function returns something already.
 *
 * @link https://github.com/haxetink/tink_core/blob/master/src/tink/core/Ref.hx
 */
abstract Ref<T>(Vector<T>)
{
    /**
     * Property to access and set the reference's value.
     *
     * @var T
     */
    public var val(get, set):T;


    /**
     * Constructor to initialize a new Ref instance.
     *
     * @param T val the value to point to
     */
    private inline function new(val:T):Void
    {
        this    = new Vector<T>(1);
        this[0] = val;
    }

    /**
     * Internal getter and type conversion method for the 'val' property.
     *
     * @return T
     */
    @:to private inline function get_val():T
    {
        return this[0];
    }

    /**
     * Internal setter method for the 'val' property.
     *
     * @param T val the value to set
     *
     * @return T the new value
     */
    private inline function set_val(val:T):T
    {
        return this[0] = val;
    }

    /**
     * Type conversion method used when casting any type to a Ref.
     *
     * @param A val the value to cast/wrap
     *
     * @return lib.Ref<A> the Ref instance referencing the value
     */
    @:from public static function to<A>(val:A):Ref<A>
    {
        return new Ref<A>(val);
    }

    /**
     * @{inherit}
     */
    public inline function toString():String
    {
        return '&{${Std.string(this[0])}}';
    }
}
