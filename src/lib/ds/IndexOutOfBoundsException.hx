package lib.ds;

import haxe.PosInfos;
import lib.Exception;

/**
 *
 */
class IndexOutOfBoundsException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Index out of range", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
