package lib;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception to be thrown when an operation is not supported due to illegal state.
 *
 * This exception is ment for cases where e.g. a cleanup() function has been called
 * and the user is trying to call another function on the instance afterwards.
 */
class IllegalStateException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Illegal state for requested operation.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
