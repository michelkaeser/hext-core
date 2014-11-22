package hext.ds;

import haxe.PosInfos;
import hext.Exception;

/**
 * TODO
 */
class IndexOutOfBoundsException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "Index out of range.", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
