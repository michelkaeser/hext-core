package hext.util;

import haxe.PosInfos;
import hext.Exception;

/**
 * Abstract base exception for the hext.util.RetryHandler class.
 *
 * @abstract
 */
class RetryHandlerException extends Exception
{
    /**
     * @{inherit}
     */
    private function new(msg:Dynamic = "Uncaught RetryHandler exception.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
