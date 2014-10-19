package hext.util;

import haxe.PosInfos;
import hext.util.RetryHandlerException;

/**
 * Exception thrown by hext.util.RetryHandler when effort() doesn't successfully
 * return before the passed limit is reached.
 */
class RetryLimitReachedException extends RetryHandlerException
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Maximum number of retries reached.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
