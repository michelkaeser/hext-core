package lib.util;

import haxe.Constraints.Function;
import lib.IllegalArgumentException;
import lib.util.RetryLimitReachedException;

/**
 * Generic wrapper that can be placed around functions throwing Exceptions to
 * auto-retry several times before giving up.
 *
 * @generic T the functions return type
 *
 * @link https://github.com/kimoto/retry-handler
 */
class RetryHandler<T>
{
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
        this.fn = fn;
        if (args == null) {
            args = new Array<Dynamic>();
        }
        this.args = args;
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
     * @throws lib.util.IllegalArgumentException   if 'retries' if less than 1
     * @throws lib.util.RetryLimitReachedException if the function doesn't return successfully after 'retries' retries
     */
    public function effort(retries:Int, timeout:Float = 0.0):T
    {
        if (retries <= 0) {
            throw new IllegalArgumentException("Number of retries cannot be 0 or less.");
        }

        for (i in 0...retries) {
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
        }

        return null; // never reached
    }
}
