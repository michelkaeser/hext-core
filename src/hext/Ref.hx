package hext;

import haxe.ds.Vector;

using hext.utils.Reflector;

/**
 * Abstract helper that can be used to pass primitive types (Int, Float etc.) by reference.
 *
 * Use cases:
 *   - Storing a function's return code (e.g. 0 == OK, 1 == Failure) inside a passed argument.
 *     This can be helpful if the function returns something already.
 *
 * @link https://github.com/haxetink/tink_core/blob/master/src/tink/core/Ref.hx
 *
 * @generic T the type of value to reference
 */
abstract Ref<T>(Vector<T>)
// implements ICloneable
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
    public inline function new():Void
    {
        this = new Vector<T>(1);
    }

    /**
     * @{inherit}
     */
    public function clone():Ref<T>
    {
        var ref:Ref<T> = new Ref<T>();
        ref.val = (this:Ref<Dynamic>).val.clone();

        return ref;
    }

    /**
     * Internal getter and type conversion method for the 'val' property.
     *
     * @return T
     */
    @:noCompletion
    @:to private inline function get_val():T
    {
        return this[0];
    }

    /**
     * Internal setter method for the 'val' property.
     *
     * @param T val the value to set
     *
     * @return T
     */
    @:noCompletion
    private function set_val(val:T):T
    {
        return this[0] = val;
    }

    /**
     * Type conversion method used when casting any type to a Ref.
     *
     * @param A val the value to cast/wrap
     *
     * @return hext.Ref<A> the Ref instance referencing the value
     */
    @:noCompletion @:noUsing
    @:from public static function to<A>(val:A):Ref<A>
    {
        var ref:Ref<A> = new Ref<A>();
        ref.val = val;

        return ref;
    }

    /**
     * @{inherit}
     */
    public inline function toString():String
    {
        return '&{${Std.string(this[0])}}';
    }
}
