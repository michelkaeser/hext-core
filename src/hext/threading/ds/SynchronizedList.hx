package hext.threading.ds;

import haxe.Serializer;
import haxe.Unserializer;
import hext.Exception;
import hext.ICloneable;
import hext.ISerializable;
import hext.threading.ds.SynchronizedIterator;
import hext.utils.Predicator;
import hext.vm.Mutex;

using hext.ListTools;
using hext.utils.Reflector;

/**
 * Synchronized List implementation for usage in multi-threaded applications.
 *
 * TODO: length
 *
 * @link http://api.haxe.org/List.html
 *
 * @generic T the type of items the List can store
 */
class SynchronizedList<T> extends List<T>
implements ICloneable<SynchronizedList<T>> implements ISerializable
{
    /**
     * Stores the Mutex used to sync method access.
     *
     * @var hext.vm.Mutex
     */
    @:final private var mutex:Mutex;


    /**
     * Constructor to initialize a new SynchronizedList.
     */
    public function new():Void
    {
        super();
        this.mutex = new Mutex();
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Void
    {
        this.mutex.acquire();
        try {
            super.add(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    override public function clear():Void
    {
        this.mutex.acquire();
        try {
            super.clear();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    public function clone():SynchronizedList<T>
    {
        var clone:SynchronizedList<T> = new SynchronizedList<T>();
        this.mutex.acquire();
        try {
            clone.addAll(this);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return clone;
    }

    /**
     * @{inherit}
     */
    override public function filter(filter:Predicator<T>):SynchronizedList<T>
    {
        var filtered:SynchronizedList<T> = new SynchronizedList<T>();
        this.mutex.acquire();
        try {
            for (item in super.iterator()) {
                if (filter(item)) {
                    filtered.add(item);
                }
            }
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return filtered;
    }

    /**
     * @{inherit}
     */
    override public function first():Null<T>
    {
        var first:Null<T>;
        this.mutex.acquire();
        try {
            first = super.first();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return first;
    }

    /**
     * Returns a synchronized List containing all the items from 'list'.
     *
     * Note: If the passed-in List is already synchronized, it is simply returned.
     *
     * @param List<G> list the List to get a synchronized version of
     *
     * @return hext.threading.ds.SynchronizedList<G> the synchronized List
     */
    public static function fromList<G>(list:List<G>):SynchronizedList<G>
    {
        var synced:SynchronizedList<G>;
        if (Std.is(list, SynchronizedList)) {
            synced = cast list;
        } else {
            synced = new SynchronizedList<G>();
            synced.addAll(list);
        }

        return synced;
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.toList());
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.mutex              = new Mutex();
        var items:List<Dynamic> = unserializer.unserialize();
        this.addAll(items); // TODO: fails on CS, Neko
    }

    /**
     * @{inherit}
     */
    override public function isEmpty():Bool
    {
        var empty:Bool;
        this.mutex.acquire();
        try {
            empty = super.isEmpty();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return empty;
    }

    /**
     * @{inherit}
     */
    override public function join(sep:String):String
    {
        var joined:String;
        this.mutex.acquire();
        try {
            joined = super.join(sep);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return joined;
    }

    /**
     * @{inherit}
     */
    override public function last():Null<T>
    {
        var last:Null<T>;
        this.mutex.acquire();
        try {
            last = super.last();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return last;
    }

    /**
     * @{inherit}
     */
    override public function map<G>(mapper:T->G):SynchronizedList<G>
    {
        var mapped:SynchronizedList<G> = new SynchronizedList<G>();
        this.mutex.acquire();
        try {
            for (item in super.iterator()) {
                mapped.add(mapper(item));
            }
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return mapped;
    }

    /**
     * @{inherit}
     */
    override public function pop():Null<T>
    {
        var pop:Null<T>;
        this.mutex.acquire();
        try {
            pop = super.pop();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return pop;
    }

    /**
     * @{inherit}
     */
    override public function push(item:T):Void
    {
        this.mutex.acquire();
        try {
            super.push(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        var removed:Bool;
        this.mutex.acquire();
        try {
            removed = super.remove(item);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return removed;
    }

    /**
     * Returns a non-synchronized List containing the items from the current instance.
     *
     * @return List<T>
     */
    public function toList():List<T>
    {
        var list:List<T> = new List<T>();
        this.mutex.acquire();
        try {
            list.addAll(this);
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw ex;
        }
        this.mutex.release();

        return list;
    }

    /**
     * @{inherit}
     */
    override public function toString():String
    {
        var str:String;
        this.mutex.acquire();
        try {
            str = super.toString();
        } catch (ex:Dynamic) {
            this.mutex.release();
            throw new Exception(ex);
        }
        this.mutex.release();

        return str;
    }
}
