package hext.vm;

import haxe.Serializer;
import haxe.Unserializer;
import hext.ICloneable;
import hext.IllegalArgumentException;
import hext.ISerializable;
import hext.UnsupportedOperationException;
import hext.threading.ISynchronizer;
import hext.threading.Synchronizer;
import hext.vm.ILock;
import hext.vm.Lock;

/**
 * Lock decorator that requires multiple release calls before the Lock gets released.
 *
 * Use cases:
 *   - Waiting for two Threads. Instead of having two regular Locks, one NumLock is enough.
 */
class NumLock implements ILock
implements ICloneable<NumLock> implements ISerializable
{
    /**
     * Stores the decorated Lock.
     *
     * @var hext.vm.ILock
     */
    @:final private var handle:ILock;

    /**
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var hext.threading.ISynchronizer
     */
    @:final private var synchronizer:ISynchronizer;

    /**
     * Stores the number of times the Lock needs to be released.
     *
     * @var Int
     */
    @:final private var times:Int;

    /**
     * Stores the number of releases.
     *
     * @var Int
     */
    private var releases:Int;


    /**
     * Constructor to initialize a new NumLock.
     *
     * @param hext.vm.ILock lock  the Lock to decorate
     * @param Int           times the num of required released
     *
     * @throws hext.IllegalArgumentException if 'times' is less than 1
     */
    public function new(lock:ILock, times:Int):Void
    {
        if (times <= 0) {
            throw new IllegalArgumentException("Number of needed relases cannot be less than 1.");
        }

        this.handle       = lock;
        this.synchronizer = new Synchronizer();
        this.times        = times;
        this.releases     = 0;
    }

    /**
     * @{inherit}
     */
    public function clone():NumLock
    {
        throw new UnsupportedOperationException("hext.vm.NumLock instances cannot be cloned.");
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.NumLock instances cannot be serialized.");
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.NumLock instances cannot be unserialized.");
    }

    /**
     * @{inherit}
     */
    public function release():Void
    {
        this.synchronizer.sync(function():Void {
            if (++this.releases == this.times) {
                this.handle.release();
                this.releases = 0;
            }
        });
    }

    /**
     * @{inherit}
     */
    public function wait(?timeout:Float = -1.0):Bool
    {
        return this.handle.wait(timeout);
    }
}
