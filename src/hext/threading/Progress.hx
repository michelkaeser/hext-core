package hext.threading;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.ds.StringMap;
import hext.Callback;
import hext.ICloneable;
import hext.IllegalArgumentException;
import hext.ISerializable;
import hext.threading.IProgress;
import hext.threading.ds.SynchronizedList;
import hext.utils.Reflector;
import hext.vm.MultiLock;
import hext.vm.Mutex;

using hext.IteratorTools;
using hext.IterableTools;

/**
 * @{inherit}
 *
 * Use cases:
 *   - Uploading a file to a remote server and showing the progress to the user.
 *   - Compressing input bytes...
 *   - Unlocking archivements as soon as the user solved 50% of the quiz.
 */
class Progress implements IProgress
implements ICloneable<Progress> implements ISerializable
{
    /**
     * Stores the registered value change listeners.
     *
     * @var hext.threading.ds.SynchronizedList<hext.Callback<Float>>
     */
    @:final private var listeners:SynchronizedList<Callback<Float>>;

    /**
     * Stores the Mutex used to perform atomic operations.
     *
     * @var hext.vm.Mutex
     */
    @:final private var mutex:Mutex;

    /**
     * Stores the actual progress value (e.g. 0.8).
     *
     * @var Float
     */
    @:isVar public var value(get, null):Float;

    /**
     * Stores the map of awaited values and the Locks blocking the waiters.
     *
     * @var haxe.ds.StringMap<hext.vm.MultiLock>
     */
    @:final private var valueLocks:StringMap<MultiLock>;


    /**
     * Constructor to initialize a new Progress instance.
     */
    public function new():Void
    {
        this.listeners    = new SynchronizedList<Callback<Float>>();
        this.mutex        = new Mutex();
        this.value        = 0.0;
        this.valueLocks   = new StringMap<MultiLock>();
    }

    /**
     * @{inherit}
     */
    public function attachValueListener(listener:Callback<Float>):Bool
    {
        var added:Bool = false;
        if (!this.listeners.contains(listener)) {
            this.listeners.add(listener);
            added = true;
        }

        return added;
    }

    /**
     * @{inherit}
     */
    public function await(value:Float):Void
    {
        if (value > 1.0) {
            throw new IllegalArgumentException("Cannot await a value greater than 1.");
        }

        // keep an eye on that. may need try/catch so the mutex is released in case of a failure
        var lock:MultiLock = null;
        this.mutex.acquire();
        if (value > this.value) {
            var val:String = Std.string(value);
            lock           = this.valueLocks.get(val);
            if (lock == null) {
                lock = new MultiLock();
                this.valueLocks.set(val, lock);
            }
        }
        this.mutex.release();

        #if java
            lock.wait();
        #else
            while (!lock.wait(0.01) && this.value < value) {}
        #end
    }

    /**
     * @{inherit}
     */
    public function clone():Progress
    {
        var clone:Progress = new Progress();
        clone.setValue(this.value);

        return clone;
    }

    /**
     * @{inherit}
     */
    public function dettachValueListener(listener:Callback<Float>):Bool
    {
        var removed:Bool = false;
        if (!this.listeners.contains(listener)) {
            this.listeners.remove(listener);
            removed = true;
        }

        return removed;
    }

    /**
     * Internal getter method for the value_data property.
     *
     * @return Float
     */
    private function get_value():Float
    {
        var value:Float;
        this.mutex.acquire();
        value = this.value;
        this.mutex.release();

        return value;
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.value);
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.listeners    = new SynchronizedList<Callback<Float>>();
        this.mutex        = new Mutex();
        this.value        = unserializer.unserialize();
        this.valueLocks   = new StringMap<MultiLock>();
    }

    /**
     * @{inherit}
     */
    public inline function isCompleted():Bool
    {
        return Math.abs(this.value - 1.0) <= 0.000001;
    }

    /**
     * Notifies all value change listeners about a change.
     *
     * @param Float value the new value
     */
    private function notifyListeners(value:Float):Void
    {
        for (listener in this.listeners.clone()) { // listener = Callback<Float>
            #if HEXT_DEBUG
                listener(value);
            #else
                try {
                    listener(value);
                } catch (ex:Dynamic) {}
            #end
        }
    }

    /**
     * Releases all Locks awaiting a value less or equal to value.
     *
     * @param Float value the value up to which Locks should be released
     */
    private function releaseLocks(value:Float):Void
    {
        for (key in this.valueLocks.keys().toList()) {
            if (Std.parseFloat(key) <= value) {
                this.valueLocks.get(key).release();
                this.valueLocks.remove(key);
            }
        }
    }

    /**
     * @{inherit}
     */
    public function setValue(value:Float):Float
    {
        if (value < 0.0) {
            throw new IllegalArgumentException("Cannot set a value smaller than 0.");
        }
        if (value > 1.0) {
            throw new IllegalArgumentException("Cannot set a value greater than 1.");
        }

        this.mutex.acquire();
        if (value > this.value) {
            this.value = value;
            this.notifyListeners(value);
            this.releaseLocks(value);
        }
        this.mutex.release();

        return value;
    }

    /**
     * @{inherit}
     */
    public function toString():String
    {
        return Std.string(this.value);
    }
}
