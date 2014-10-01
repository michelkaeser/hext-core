package lib;

import haxe.PosInfos;
import lib.Throwable;

/**
 * Base class for errors to be thrown when compile or runtime exceptions
 * encounter that should be fetchable.
 */
class Exception extends Throwable
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Uncaugth Exception thrown.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
