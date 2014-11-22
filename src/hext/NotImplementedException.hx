package hext;

import haxe.PosInfos;
import hext.UnsupportedOperationException;

/**
 * Exception to be thrown when the called method is not yet implemented.
 *
 * Throwing this exception is a 'temporary' fix. To signalize that a method will never
 * do anything, the UnsupportedOperationException should be used instead.
 *
 * Use cases:
 *   - As Haxe doesn't support abstract methods, the base class might throw this in a
 *     'to-be-overriden' method.
 *   - One had to urgently release a class but did not have time to implement all methods yet.
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
