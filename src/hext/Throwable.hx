package hext;

import haxe.CallStack;
import haxe.PosInfos;

using hext.utils.Reflector;
using StringTools;

/**
 * The Throwable class stores position, call- and exception stack
 * information and should be used (but first extended) to signalize errors/exceptions
 * as it helps finding bugs and program faults by providing the initially mentioned
 * information to the developer.
 */
class Throwable
implements ICloneable<Throwable>
{
    /**
     * Stores the method call stack.
     *
     * @var String
     */
    @:final private var callStack:String;

    /**
     * Stores the exception stack.
     *
     * @var String
     */
    @:final private var exceptionStack:String;

    /**
     * Stores the stack position information.
     *
     * @var Null<haxe.PosInfos>
     */
    @:final private var info:Null<PosInfos>;

    /**
     * Stores the message to be displayed.
     *
     * @var Dynamic
     */
    @:final public var msg(default, null):Dynamic;


    /**
     * Constructor to initialize a new Throwable.
     *
     * @param Dynamic             msg  the message to display
     * @param Null<haxe.PosInfos> info the position information object
     */
    private function new(msg:Dynamic = "", ?info:PosInfos):Void
    {
        #if HEXT_DEBUG
            this.callStack      = CallStack.toString(CallStack.callStack());
            this.exceptionStack = CallStack.toString(CallStack.exceptionStack());
        #else
            this.exceptionStack = "Exception stack available in debug mode only.";
            this.callStack      = "Call stack available in debug mode only.";
        #end
        this.info               = info;
        this.msg                = msg;
    }

    /**
     * @{inherit}
     */
    public function clone():Throwable
    {
        var clone:Throwable  = new Throwable(this.msg.clone(), this.info.clone());
        clone.callStack      = this.callStack;
        clone.exceptionStack = this.exceptionStack;

        return clone;
    }

    /**
     * Returns the call stack.
     *
     * @return String
     */
    public function getCallStack():String
    {
        var buffer:StringBuf = new StringBuf();
        buffer.add("CallStackTrace");
        buffer.add("\n".rpad("~", 39));
        buffer.add("\n");
        buffer.add(this.callStack);

        return buffer.toString();
    }

    /**
     * Returns the exception stack.
     *
     * @return String
     */
    public function getExceptionStack():String
    {
        var buffer:StringBuf = new StringBuf();
        buffer.add("ExceptionStackTrace");
        buffer.add("\n".rpad("~", 39));
        buffer.add("\n");
        buffer.add(this.exceptionStack);

        return buffer.toString();
    }

    /**
     * Returns information about the source/where the error/exception
     * has been triggered.
     *
     * @return String
     */
    public function getSource():String
    {
        var buffer:StringBuf = new StringBuf();
        buffer.add("File: ");
        buffer.add(this.info.fileName);
        buffer.add(" | Line: ");
        buffer.add(this.info.lineNumber);
        buffer.add("\n");
        buffer.add("Class: ");
        buffer.add(this.info.className);
        buffer.add(" | Method: ");
        buffer.add(this.info.methodName);

        return buffer.toString();
    }

    /**
     * Returns a String representative of the Throwable.
     *
     * This method is useful to display all contained information at once
     * rather can calling each method by its own.
     *
     * @return String
     */
    public function toString():String
    {
        var buffer:StringBuf = new StringBuf();
        buffer.add(this.msg);
        buffer.add("\n");
        buffer.add(this.getSource());
        buffer.add("\n\n");
        buffer.add(this.getExceptionStack());
        buffer.add("\n\n");
        buffer.add(this.getCallStack());

        return buffer.toString();
    }
}
