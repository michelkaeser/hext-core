package lib.threading;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.ds.StringMap;
import lib.Callback;
import lib.IllegalArgumentException;
import lib.Serializable;
import lib.Stringable;
import lib.ds.SynchronizedSet;
import lib.ds.UnsortedSet;
import lib.threading.IProgress;
import lib.util.Reflector;
import lib.vm.IMutex;
import lib.vm.MultiLock;
import lib.vm.Mutex;

/**
 *
 */
class Progress implements IProgress implements Serializable
#if !LIB_DEBUG implements Stringable #end
{
    /**
     * Stores the registered value change listeners.
     *
     * @var lib.ds.SynchronizedSet<lib.Callback<Float>>
     */
    private var listeners:SynchronizedSet<Callback<Float>>;

    /**
     * Stores the Mutex used to synchronized access to the value property.
     *
     * @var lib.vm.IMutex
     */
    private var mutex:IMutex;

    /**
     * Stores the actual progress value (e.g. 0.8).
     *
     * @var Float
     */
    @:isVar public var value(get, null):Float;

    /**
     * Stores the map of awaited values and the Locks blocking the waiters.
     *
     * @var haxe.ds.StringMap<lib.vm.MultiLock>
     */
    private var valueLocks:StringMap<MultiLock>;


    /**
     * Constructor to initialize a new Progress instance.
     */
    public function new():Void
    {
        this.listeners  = new SynchronizedSet<Callback<Float>>(new UnsortedSet<Callback<Float>>(Reflector.compare));
        this.mutex      = new Mutex();
        this.value      = 0.0;
        this.valueLocks = new StringMap<MultiLock>();
    }

    /**
     * @{inherit}
     */
    public function attachValueListener(listener:Callback<Float>):Bool
    {
        return this.listeners.add(listener);
    }

    /**
     * @{inherit}
     */
    public function await(value:Float):Void
    {
        if (value > 1.0) {
            throw new IllegalArgumentException("Cannot await a value greater than 1.");
        }

        this.mutex.acquire();
        if (value > this.value) {
            var val:String     = Std.string(value);
            var lock:MultiLock = this.valueLocks.get(val);
            if (lock == null) {
                lock = new MultiLock();
                this.valueLocks.set(val, lock);
            }
            this.mutex.release();

            #if java
                lock.wait();
            #else
                while (!lock.wait(0.01) && this.value < value) {}
            #end
        } else {
            this.mutex.release();
        }
    }

    /**
     * @{inherit}
     */
    public function dettachValueListener(listener:Callback<Float>):Bool
    {
        return this.listeners.remove(listener);
    }

    /**
     * Internal getter method for the value_data property.
     *
     * @return Float
     */
    private function get_value():Float
    {
        this.mutex.acquire();
        var value:Float = this.value;
        this.mutex.release();

        return value;
    }

    /**
     * @{inherit}
     */
    @:keep
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.value);
    }

    /**
     * @{inherit}
     */
    @:keep
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.listeners  = new SynchronizedSet<Callback<Float>>(new UnsortedSet<Callback<Float>>(Reflector.compare));
        this.mutex      = new Mutex();
        this.value      = unserializer.unserialize();
        this.valueLocks = new StringMap<MultiLock>();
    }

    /**
     * @{inherit}
     */
    public inline function isCompleted():Bool
    {
        return this.value == 1.0;
    }

    /**
     * Notifies all value change listeners about a change.
     *
     * @param Float value the new value
     */
    private function notifyListeners(value:Float):Void
    {
        var listener:Callback<Float>;
        for (listener in this.listeners.toArray()) {
            #if LIB_DEBUG
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
        // TODO: create copy of keys since we remove within the loop
        for (key in this.valueLocks.keys()) {
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
        if (value != this.value) {
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
    #if !LIB_DEBUG
    public function toString():String
    {
        return Std.string(this.value);
    }
    #end
}
