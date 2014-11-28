package hext.vm;

#if !(cpp || cs || java || neko)
    #error "hext.vm.Thread is not available on target platform."
#end

#if cs
    import cs.system.threading.ThreadStart;
    import haxe.ds.ObjectMap;
    import hext.vm.Deque;
    import hext.vm.IDeque;
    import hext.vm.ILock;
    import hext.vm.Lock;
#end
import haxe.Serializer;
import haxe.Unserializer;
import hext.ICloneable;
import hext.ISerializable;
import hext.UnsupportedOperationException;
import hext.threading.Atomic;

/**
 * A wrapper class around the various platform specific VM Threads
 * included in Haxe Std package.
 *
 * TODO: join() method to wait for the thread
 *
 * Use cases:
 *   - Well, doing some expensive calculations in the background...
 *   - ...
 */
class Thread
implements ICloneable<Thread> implements ISerializable
{
    /**
     * Property to access the number of running threads (excl. the main thread).
     *
     * @var hext.threading.Atomic<Int>
     */
    public static var count(default, null):Atomic<Int> = new Atomic<Int>(0);

    /**
     * Stores the underlaying native Thread.
     *
     * @var hext.vm.Thread.VMThread
     */
    @:final private var handle:VMThread;

    #if cs
        /**
         * Stores the message queue.
         *
         * @var hext.vm.IDeque<Dynamic>
         */
        @:final private var messages:IDeque<Dynamic>;

        /**
         * Stores the map of Threads so we can access their messages field.
         *
         * @var ObjectMap<hext.vm.Thread.VMThread, hext.vm.Thread>
         */
        @:final private static var threads:ObjectMap<VMThread, Thread> = {
            var map    = new ObjectMap<VMThread, Thread>();
            var handle = VMThread.CurrentThread;
            map.set(handle, new Thread(handle));
            map;
        };
    #end


    /**
     * Constructor to initialize a new Thread instance.
     *
     * @param hext.vm.Thread.VMThread handle the underlaying Thread to wrap
     */
    private function new(handle:VMThread):Void
    {
        this.handle = handle;
        #if cs
            this.messages = new Deque<Dynamic>();
        #end
    }

    /**
     * @{inherit}
     */
    public function clone():Thread
    {
        throw new UnsupportedOperationException("hext.vm.Thread instances cannot be cloned.");
    }

    /**
     * Returns the current Thread object.
     *
     * @return hext.vm.Thread
     */
    public static function current():Thread
    {
        #if cs
            return new Thread(VMThread.CurrentThread);
        #else
            return new Thread(VMThread.current());
        #end
    }

    /**
     * Creates a new Thread that will execute the given function.
     *
     * @param hext.Closure fn the function to execute
     *
     * @return hext.vm.Thread
     */
    public static function create(fn:Closure):Thread
    {
        var thread:Thread;
        #if cs
            var t:VMThread = new VMThread(new ThreadStart(function():Void {
                try {
                    fn();
                } catch (ex:Dynamic) {
                    Thread.count.val -= 1;
                    Thread.threads.remove(Thread.current().handle);
                    throw ex;
                }
                Thread.count.val -= 1;
                Thread.threads.remove(Thread.current().handle);
            }));
            thread         = new Thread(t);
            t.IsBackground = true;
            Thread.threads.set(t, thread);
            Thread.count.val += 1;
            t.Start();
        #else
            Thread.count.val += 1;
            thread = new Thread(VMThread.create(function():Void {
                try {
                    fn();
                } catch (ex:Dynamic) {
                    Thread.count.val -= 1;
                    throw ex;
                }
                Thread.count.val -= 1;
            }));
        #end

        return thread;
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.Thread instances cannot be serialized.");
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        throw new UnsupportedOperationException("hext.vm.Thread instances cannot be unserialized.");
    }

    /**
     * Reads a message from the Thread's message queue.
     *
     * @param Bool block if true, execution is blocked until a message is available
     *
     * @return Null<Dynamic> the message read
     */
    public static function readMessage(block:Bool):Null<Dynamic>
    {
        #if cs
            return Thread.threads.get(VMThread.CurrentThread).messages.pop(block);
        #else
            return VMThread.readMessage(block);
        #end
    }

    /**
     * Sends a message (can be of any type) to the Thread.
     *
     * @param Dynamic msg the message to send
     *
     * @return hext.vm.Thread the 'this' instance
     */
    public function sendMessage(msg:Dynamic):Thread
    {
        #if cs
            Thread.threads.get(this.handle).messages.push(msg);
        #else
            this.handle.sendMessage(msg);
        #end

        return this;
    }
}


/**
 * Typedef to native VM Threads.
 */
typedef VMThread =
#if cpp      cpp.vm.Thread;
#elseif cs   cs.system.threading.Thread;
#elseif java java.vm.Thread;
#elseif neko neko.vm.Thread;
#end
