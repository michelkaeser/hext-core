package hext.vm;

#if !(cpp || cs || java || neko)
    #error "hext.vm.Deque is not available on target platform."
#end

import haxe.Serializer;
import haxe.Unserializer;
import hext.ICloneable;
import hext.ISerializable;
import hext.UnsupportedOperationException;
import hext.utils.Reflector;
import hext.vm.IDeque;

/**
 * @{inherit}
 */
class Deque<T> implements IDeque<T>
implements ICloneable<Deque<T>> implements ISerializable
{
    /**
     * Stores the underlaying native Deque.
     *
     * @var hext.vm.Deque.VMDeque<T>
     */
    private var handle:VMDeque<T>;


    /**
     * Constructor to initialize a new Deque instance.
     */
    public function new():Void
    {
        this.handle = new VMDeque<T>();
    }

    /**
     * @{inherit}
     */
    public function add(item:T):Void
    {
        this.handle.add(item);
    }

    /**
     * @{inherit}
     */
    public function clone():Deque<T>
    {
        throw new UnsupportedOperationException("hext.vm.Deque instances cannot be cloned.");
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.Deque instances cannot be serialized.");
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.Deque instances cannot be unserialized.");
    }

    /**
     * @{inherit}
     */
    public function pop(block:Bool):Null<T>
    {
        return this.handle.pop(block);
    }

    /**
     * @{inherit}
     */
    public function push(item:T):Void
    {
        this.handle.push(item);
    }
}


/**
 * Typedef to native VM Locks.
 */
private typedef VMDeque<T> =
#if cpp      cpp.vm.Deque<T>;
#elseif cs   hext.cs.haxe.Deque<T>;
#elseif java java.vm.Deque<T>;
#elseif neko neko.vm.Deque<T>;
#end

