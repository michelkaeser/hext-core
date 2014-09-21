package lib.vm;

/**
 *
 */
interface IDeque<T>
{
    /**
     *
     */
    public function add(item:T):Void;

    /**
     *
     */
    public function pop(block:Bool):Null<T>;

    /**
     *
     */
    public function push(item:T):Void;
}
