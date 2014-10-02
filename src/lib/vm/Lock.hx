package lib.vm;

#if !(cpp || cs || java || neko)
    #error "lib.vm.Lock is not available on target platform."
#end

import lib.vm.ILock;

/**
 * @{inherit}
 *
 * Use cases:
 *   - Block function callers until the internal state (working -> done) changes.
 */
class Lock implements ILock
{
    /**
     * Stores the underlaying native Lock.
     *
     * @var lib.vm.Lock.VMLock
     */
    private var handle:VMLock;

    /**
     * Constructor to initialize a new Lock instance.
     */
    public function new():Void
    {
        this.handle = new VMLock();
    }

    /**
     * @{inherit}
     */
    public function release():Void
    {
        this.handle.release();
    }

    /**
     * @{inherit}
     */
    public function wait(?timeout:Float = -1.0):Bool
    {
        #if (java || neko)
            if (timeout == -1.0) {
                timeout = null;
            }
        #end

        return this.handle.wait(timeout);
    }
}


/**
 * Typedef to native VM Locks.
 */
private typedef VMLock =
#if cpp      cpp.vm.Lock;
#elseif cs   lib.cs.haxe.Lock;
#elseif java java.vm.Lock;
#elseif neko neko.vm.Lock;
#end
