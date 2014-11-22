package hext.java.util.concurrent;

#if !java
    #error "hext.java.util.concurrent.Semaphore is only available on Java target"
#end

/**
 * A counting semaphore. Conceptually, a semaphore maintains a set of permits.
 * Each acquire() blocks if necessary until a permit is available, and then takes it.
 * Each release() adds a permit, potentially releasing a blocking acquirer. However, no actual permit objects are used;
 * the Semaphore just keeps a count of the number available and acts accordingly.
 *
 * @link http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html
 */
@:native('java.util.concurrent.Semaphore') extern class Semaphore
{
    /**
     * Creates a Semaphore with the given number of permits and nonfair fairness setting.
     *
     * @link http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#Semaphore-int-
     *
     * @param Int permits the initial number of permits available. This value may be negative, in which case releases must occur before any acquires will be granted.
     */
    public function new(permits:Int):Void;

    /**
     * Acquires the given number of permits from this semaphore, blocking until all are available,
     * or the thread is interrupted.
     *
     * @link http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#acquire--
     */
    public function acquire():Void;

    /**
     * Acquires a permit from this semaphore, only if one is available at the time of invocation.
     *
     * @link http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#tryAcquire--
     *
     * @return Bool true if a permit was acquired and false otherwise
     */
    public function tryAcquire():Bool;

    /**
     * Releases a permit, returning it to the semaphore.
     *
     * @link http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#release--
     */
    public function release():Void;
}
