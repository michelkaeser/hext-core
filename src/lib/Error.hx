package lib;

import haxe.PosInfos;
import lib.Throwable;

/**
 * Errors are in contrast to exceptions not catchable
 * and should be used to signalize a fatal error within the application
 * that requires/leads to an immediate shutdown.
 *
 * Use cases:
 *   - Signalizing an error that should not be catched. For example type casting errors.
 */
class Error extends Throwable
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "A fatal error encountered.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
