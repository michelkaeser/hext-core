package lib.util;

import haxe.PosInfos;
import lib.util.RetryHandlerException;

/**
 * Exception thrown by lib.util.RetryHandler when effort() doesn't successfully
 * return before the abort() method is called.
 */
class RetryHandlerAbortedException extends RetryHandlerException
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Retry handler has been aborted.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
