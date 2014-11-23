package hext.ds;

import haxe.PosInfos;
import hext.Exception;

/**
 * Exception to be thrown when trying to access an item by index
 * and the index is larger/lower then the number of items contained
 * within the data structure.
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
