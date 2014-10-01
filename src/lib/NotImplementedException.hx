package lib;

import haxe.PosInfos;
import lib.UnsupportedOperationException;

/**
 * Exception to be thrown when the called method is not yet implemented.
 *
 * Throwing this exception is a temporary fix. To signalize that a method will never
 * do anything, the UnsupportedOperationException should be used instead.
 */
class NotImplementedException extends UnsupportedOperationException
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Requested method not implemented.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
