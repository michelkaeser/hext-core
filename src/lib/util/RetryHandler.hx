package lib.util;

import haxe.Constraints.Function;
import lib.IllegalArgumentException;
import lib.threading.Atomic;
import lib.util.RetryHandlerAbortedException;
import lib.util.RetryLimitReachedException;

/**
 * Generic wrapper that can be placed around functions throwing Exceptions to
 * auto-retry several times before giving up.
 *
 * Use cases:
 *   - Trying to communicate with an external server. It might have problems right now,
 *     but before notifiying the user about that, we just try some more times as the failure
 *     might be temporary.
 *
 * @link https://github.com/kimoto/retry-handler
 *
 * @generic T the functions return type
 */
class RetryHandler<T>
{
    /**
     * Stores either 'effort' should stop after the current retry.
     *
     * @var lib.threading.Atomic<Bool>
     */
    private var aborted:Atomic<Bool>;

    /**
     * Stores the arguments to pass when calling the function.
     *
     * @var Array<Dynamic>
     */
    private var args:Array<Dynamic>;

    /**
     * Stores the function to be called.
     *
     * @var haxe.Constraints.Function
     */
    private var fn:Function;


    /**
     * Constructor to initialize a new RetryHandler.
     *
     * @param haxe.Constraints.Function fn   the function to call
     * @param Null<Array<Dynamic>>      args the args with which the fn should be called
     */
    public function new(fn:Function, ?args:Array<Dynamic>):Void
    {
        this.aborted = false;
        this.fn      = fn;
        if (args == null) {
            args = new Array<Dynamic>();
        }
        this.args = args;
    }

    /**
     * Tells the 'effort' function to abort after the current retry.
     */
    public function abort():Void
    {
        this.aborted.val = true;
    }

    /**
     * Executes the wrapped function up to 'retries' time.
     *
     * Note: The 'timeout' parameter is ignored on non-Sys targets.
     *
     * @param Int   retries the max number of retries
     * @param Float timeout a timeout to wait before trying again after a failure
     *
     * @return T
     *
     * @throws lib.util.IllegalArgumentException     if 'retries' if less than 1
     * @throws lib.util.RetryLimitReachedException   if the function doesn't return successfully after 'retries' retries
     * @throws lib.util.RetryHandlerAbortedException if the abort call has ended the retry loop
     */
    public function effort(retries:Int, timeout:Float = 0.0):T
    {
        if (retries <= 0) {
            throw new IllegalArgumentException("Number of retries cannot be 0 or less.");
        }

        this.aborted.val = false;
        var i:Int = 0;
        while (!this.aborted.val && i < retries) {
            try {
                return Reflect.callMethod(this, this.fn, this.args);
            } catch (ex:Dynamic) {
                if (i == retries - 1) {
                    throw new RetryLimitReachedException(ex);
                }

                #if sys
                    if (timeout > 0.0) {
                        Sys.sleep(timeout);
                    }
                #end
            }
            ++i;
        }

        throw new RetryHandlerAbortedException();
    }
}
