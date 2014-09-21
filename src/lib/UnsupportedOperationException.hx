package lib;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception to be thrown when the called method is not supported.
 *
 * This exception is recommended for classes inheriting from interfaces or abstract classes
 * where some methods do not make sense in context.
 */
class UnsupportedOperationException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Requested operation not supported", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
