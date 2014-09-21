package lib.util;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception thrown by lib.util.RetryHandler when effort() doesn't successfully
 * return before the passed limit is reached.
 */
class RetryLimitReachedException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Maximum number of retries reached", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
