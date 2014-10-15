package lib.vm;

#if !(cpp || cs || java || neko)
    #error "lib.vm.Deque is not available on target platform."
#end

import lib.vm.IDeque;

/**
 * @{inherit}
 */
class Deque<T> implements IDeque<T>
{
    /**
     * Stores the underlaying native Deque.
     *
     * @var lib.vm.Deque.VMDeque<T>
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
#elseif cs   lib.cs.haxe.Deque<T>;
#elseif java java.vm.Deque<T>;
#elseif neko neko.vm.Deque<T>;
#end

