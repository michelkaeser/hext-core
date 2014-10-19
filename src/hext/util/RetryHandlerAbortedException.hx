package hext.util;

import haxe.PosInfos;
import hext.util.RetryHandlerException;

/**
 * Exception thrown by hext.util.RetryHandler when effort() doesn't successfully
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
