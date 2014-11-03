package hext.threading;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.ds.StringMap;
import hext.Callback;
import hext.IllegalArgumentException;
import hext.ISerializable;
import hext.IStringable;
import hext.ds.SynchronizedSet;
import hext.ds.UnsortedSet;
import hext.threading.IProgress;
import hext.threading.ISynchronizer;
import hext.threading.Synchronizer;
import hext.utils.Reflector;
import hext.vm.MultiLock;

/**
 * Use cases:
 *   - Uploading a file to a remote server and showing the progress to the user.
 *   - Compressing input bytes...
 *   - Unlocking archivements as soon as the user solved 50% of the quiz.
 */
class Progress implements IProgress implements ISerializable implements IStringable
{
    /**
     * Stores the registered value change listeners.
     *
     * @var hext.ds.SynchronizedSet<hext.Callback<Float>>
     */
    private var listeners:SynchronizedSet<Callback<Float>>;

    /**
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var hext.threading.ISynchronizer
     */
    private var synchronizer:ISynchronizer;

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
    private var valueLocks:StringMap<MultiLock>;


    /**
     * Constructor to initialize a new Progress instance.
     */
    public function new():Void
    {
        this.listeners    = new SynchronizedSet<Callback<Float>>(new UnsortedSet<Callback<Float>>(Reflector.compare));
        this.synchronizer = new Synchronizer();
        this.value        = 0.0;
        this.valueLocks   = new StringMap<MultiLock>();
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

        var lock:MultiLock = null;
        this.synchronizer.sync(function():Void {
            if (value > this.value) {
                var val:String = Std.string(value);
                lock           = this.valueLocks.get(val);
                if (lock == null) {
                    lock = new MultiLock();
                    this.valueLocks.set(val, lock);
                }
            }
        });

        #if java
            lock.wait();
        #else
            while (!lock.wait(0.01) && this.value < value) {}
        #end
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
        var value:Float;
        this.synchronizer.sync(function():Void {
            value = this.value;
        });

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
        this.listeners    = new SynchronizedSet<Callback<Float>>(new UnsortedSet<Callback<Float>>(Reflector.compare));
        this.synchronizer = new Synchronizer();
        this.value        = unserializer.unserialize();
        this.valueLocks   = new StringMap<MultiLock>();
    }

    /**
     * @{inherit}
     */
    public function isCompleted():Bool
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

        this.synchronizer.sync(function():Void {
            if (value != this.value) { // TODO: float comparison
                this.value = value;
                this.notifyListeners(value);
                this.releaseLocks(value);
            }
        });

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
