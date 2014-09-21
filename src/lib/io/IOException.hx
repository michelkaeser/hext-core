package lib.io;

import haxe.PosInfos;
import lib.Exception;

/**
 * Exception to be thrown when an operation on an IO device/file went south.
 *
 * Classes/methods requiring access/data from a filesystem file or directory
 * should throw this exception when the file/directory is not openable etc.
 */
class IOException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Failed I/O operation", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
