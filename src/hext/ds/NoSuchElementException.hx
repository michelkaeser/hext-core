package hext.ds;

import haxe.PosInfos;
import hext.Exception;

/**
 * TODO
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
