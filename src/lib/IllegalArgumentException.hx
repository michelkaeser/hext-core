package lib;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception to be thrown when one or more arguments are invalid/illegal.
 */
class IllegalArgumentException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Illegal argument passed to method.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
