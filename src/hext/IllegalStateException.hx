package hext;

import haxe.PosInfos;
import hext.Exception;

/**
 * Exception to be thrown when an operation is not supported due to illegal state.
 *
 * Use cases:
 *   - A cleanup() function has been called and the user is trying
 *     to call another function on the instance afterwards that depends on a destroyed variable.
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
