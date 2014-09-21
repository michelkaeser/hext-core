package lib.vm;

/**
 *
 */
interface IMutex
{
    /**
     * Acquires the Mutex.
     *
     * If the Mutex has already been acquired by another Thread,
     * the calling Thread gets blocked until access is granted.
     */
    public function acquire():Void;

    /**
     * Releases the Mutex.
     */
    public function release():Void;
}
