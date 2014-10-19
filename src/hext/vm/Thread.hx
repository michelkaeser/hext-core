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

/**
 * A wrapper class around the various platform specific VM Threads
 * included in Haxe Std package.
 *
 * Use cases:
 *   - Well, doing some expensive calculations in the background...
 *   - ...
 */
class Thread
{
    /**
     * Stores the underlaying native Thread.
     *
     * @var hext.vm.Thread.VMThread
     */
    private var handle:VMThread;

    #if cs
        /**
         * Stores the message queue.
         *
         * @var hext.vm.IDeque<Dynamic>
         */
        private var messages:IDeque<Dynamic>;

        /**
         * Stores the map of Threads so we can access their messages field.
         *
         * @var ObjectMap<hext.vm.Thread.VMThread, hext.vm.Thread>
         */
        private static var threads:ObjectMap<VMThread, Thread> = {
            var map    = new ObjectMap<VMThread, Thread>();
            var handle = VMThread.CurrentThread;
            map.set(handle, new Thread(handle));
            map;
        }
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
                fn();
                Thread.threads.remove(Thread.current().handle);
            }));
            thread         = new Thread(t);
            t.IsBackground = true;
            Thread.threads.set(t, thread);
            t.Start();
        #else
            thread = new Thread(VMThread.create(fn));
        #end

        return thread;
    }

    /**
     * Reads a message from the Thread's message queue.
     *
     * @param Bool block if true, execution is blocked until a message is available
     *
     * @return Null<Dynamic> the message
     */
    public static #if !cs inline #end function readMessage(block:Bool):Null<Dynamic>
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
     * @return hext.vm.Thread
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