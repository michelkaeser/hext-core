package lib.ds;

import haxe.PosInfos;
import lib.Exception;

/**
 *
 */
class NoSuchElementException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "No such element.", ?info:PosInfos) : Void
    {
        super(msg, info);
    }
}
