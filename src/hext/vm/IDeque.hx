package hext.vm;

/**
 * TODO
 */
interface IDeque<T>
{
    /**
     * TODO
     */
    public function add(item:T):Void;

    /**
     * TODO
     */
    public function pop(block:Bool):Null<T>;

    /**
     * TODO
     */
    public function push(item:T):Void;
}
