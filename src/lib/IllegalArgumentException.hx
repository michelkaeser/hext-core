package lib;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception to be thrown when one or more arguments are invalid/illegal.
 *
 * Use cases:
 *   - If a function accepts either '0' or '1' and the caller passes '2' as an argument.
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
