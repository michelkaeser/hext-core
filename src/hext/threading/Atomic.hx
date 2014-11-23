package hext.threading;

#if (cpp || cs || java || neko)
    import hext.threading.ISynchronizer;
    import hext.threading.Synchronizer;
#end

using hext.utils.Reflector;

/**
 * Abstract helper that can be used to make any type thread safe.
 *
 * Use cases:
 *   - Having a read/write only (no further actions are done depending on its value) variable
 *     that is accessed by multiple threads and thus needs some kind of synchronization to prevent
 *     memory corruption.
 *
 * @generic T the type of the value to wrap
 */
abstract Atomic<T>(#if (cpp || cs || java || neko) { value:T, synchronizer:ISynchronizer } #else T #end)
// implements ICloneable
{
    /**
     * Property to access and set the Atomic's value.
     *
     * @var T
     */
    public var val(get, set):T;


    /**
     * Constructor to initialize a new Atomic instance.
     *
     * @param T val the initial value to set
     */
    private inline function new(val:T):Void
    {
        #if (cpp || cs || java || neko)
            this = { value: val, synchronizer: new Synchronizer() };
        #else
            this = val;
        #end
    }

    /**
     * @{inherit}
     */
    public function clone():Atomic<T>
    {
        return new Atomic<T>((cast this:Atomic<Dynamic>).val.clone());
    }

    /**
     * Type conversion method used when casting any type to an Atomic.
     *
     * @param A val the value to cast/wrap
     *
     * @return hext.threading.Atomic<A>
     */
    @:noCompletion @:noUsing
    @:from public static function from<A>(val:A):Atomic<A>
    {
        return new Atomic<A>(val);
    }

    /**
     * Internal getter method for the 'val' property.
     *
     * @return T
     */
    @:noCompletion
    @:to private function get_val():T
    {
        var val:T;
        #if (cpp || cs || java || neko)
            this.synchronizer.sync(function():Void {
                val = this.value;
            });
        #else
            val = this;
        #end

        return val;
    }

    /**
     * Internal setter method for the 'val' property.
     *
     * @param T val the value to set
     *
     * @return T
     */
    @:noCompletion
    private #if !(cpp || cs || java || neko) inline #end function set_val(val:T):T
    {
        #if (cpp || cs || java || neko)
            this.synchronizer.sync(function():Void {
                this.value = val;
            });
        #else
            this = val;
        #end

        return val;
    }

    /**
     * @{inherit}
     */
    public function toString():String
    {
        return Std.string((cast this:Atomic<Dynamic>).val);
    }
}
