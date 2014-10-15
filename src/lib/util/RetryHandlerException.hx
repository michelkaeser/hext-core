package lib.util;

import haxe.PosInfos;
import lib.Exception;

/**
 * Abstract base exception for the lib.util.RetryHandler class.
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
