package lib.threading;

#if (cpp || cs || java || neko)
    import lib.vm.IMutex;
    import lib.vm.Mutex;
#end

/**
 *
 */
abstract Atomic<T>(#if (cpp || cs || java || neko) { value:T, mutex:IMutex } #else T #end)
{
    /**
     *
     */
    public var val(get, set):T;


    /**
     *
     */
    private inline function new(val:T):Void
    {
        #if (cpp || cs || java || neko)
            this = { value: val, mutex: new Mutex() };
        #else
            this = val;
        #end
    }

    /**
     *
     */
    @:noCompletion @:noUsing
    @:from public static function from<A>(val:A):Atomic<A>
    {
        return new Atomic<A>(val);
    }

    /**
     *
     */
    @:noCompletion
    @:to private #if !(cpp || cs || java || neko) inline #end function get_val():T
    {
        var val:T;
        #if (cpp || cs || java || neko)
            this.mutex.acquire();
            val = this.value;
            this.mutex.release();
        #else
            val = this;
        #end

        return val;
    }

    /**
     *
     */
    @:noCompletion
    private #if !(cpp || cs || java || neko) inline #end function set_val(val:T):T
    {
        #if (cpp || cs || java || neko)
            this.mutex.acquire();
            this.value = val;
            this.mutex.release();
        #else
            this = val;
        #end

        return val;
    }
}
