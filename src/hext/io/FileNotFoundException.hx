package hext.io;

import haxe.PosInfos;
import hext.io.IOException;

/**
 * Exception to be thrown when a file or directory can not be found.
 *
 * Classes/methods requiring access/data from a filesystem file or directory
 * should throw this exception when the file/directory is not available.
 *
 * When the file/directory exists but is not readable etc. an
 * IOException should be thrown instead.
 */
class FileNotFoundException extends IOException
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "No such file or directory.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
