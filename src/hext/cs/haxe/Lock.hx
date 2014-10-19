package hext.cs.haxe;

#if !cs
    #error "hext.cs.haxe.Lock is only available on C# target."
#end

#if LIB_WIN
    import hext.cs.system.threading.SemaphoreSlim;
#else
    import hext.cs.system.threading.Semaphore;
#end

/**
 * Abstract C# Lock wrapper.
 */
abstract Lock(#if HEXT_WIN SemaphoreSlim #else Semaphore #end)
{
    /**
     * Constructor to initialize a new Lock.
     */
    public inline function new():Void
    {
        #if HEXT_WIN
            this = new SemaphoreSlim(0, 100);
        #else
            this = new Semaphore(0, 100);
        #end
    }

    /**
     * @{inherit}
     */
    public inline function release():Void
    {
        this.Release();
    }

    /**
     * @{inherit}
     */
    public function wait(?timeout:Float = -1.0):Bool
    {
        if (timeout != -1.0) {
            timeout = timeout * 1000;
        }

        #if HEXT_WIN
            return this.Wait(Std.int(timeout));
        #else
            return this.WaitOne(Std.int(timeout));
        #end
    }
}
