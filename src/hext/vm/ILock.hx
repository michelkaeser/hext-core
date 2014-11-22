package hext.vm;

/**
 * TODO
 */
interface ILock
{
    /**
     * Releases the Lock.
     */
    public function release():Void;

    /**
     * Waits for the Lock to be released.
     *
     * @param Null<Float> timeout the maximal time to wait
     *
     * @return Bool true if unlocked before the timeout exceeds
     */
    public function wait(?timeout:Float = -1.0):Bool;
}
