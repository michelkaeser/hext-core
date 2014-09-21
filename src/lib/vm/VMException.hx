package lib.vm;

import haxe.PosInfos;
import lib.Exception;

/**
 * Excpetions to be thrown when VM exceptions encounter.
 */
class VMException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:Dynamic = "VM related exception encountered", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
