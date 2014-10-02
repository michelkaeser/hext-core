package lib;

import haxe.PosInfos;
import lib.Throwable;

/**
 * Base class for errors to be thrown when compile or runtime exceptions
 * encounter that should be fetchable.
 *
 * Use cases:
 *   - In I/O operations to signliaze a temporary failure (e.g out of space)
 *   - In DS to signalize access to invalid data
 *   - ...
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
