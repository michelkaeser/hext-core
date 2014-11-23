package hext.threading;

import haxe.Serializer;
import haxe.Unserializer;
import hext.Closure;
import hext.ICloneable;
import hext.ISerializable;
import hext.UnsupportedOperationException;
import hext.threading.ISynchronizer;
import hext.vm.Mutex;

/**
 * Standard Synchronizer implmenetation using Mutexes.
 *
 * Use cases:
 *   - Synchronize various code blocks within your application/class. Instead of managing your
 *     own mutex, you simply call to-be-synchronized calls through the Synchronizer.
 */
class Synchronizer implements ISynchronizer
implements ICloneable<Synchronizer> implements ISerializable
{
    #if (cpp || cs || java || neko)
        /**
         * Stores the Mutex used to ensure only one Thread a time is executing the sync
         * function.
         *
         * @var hext.vm.Mutex
         */
        @:final private var mutex:Mutex;
    #end


    /**
     * Constructor to initialize a new Synchronizer.
     */
    public function new():Void
    {
        #if (cpp || cs || java || neko)
            this.mutex = new Mutex();
        #end
    }

    /**
     * @{inherit}
     */
    public function clone():Synchronizer
    {
        return new Synchronizer();
    }

    /**
     * @{inherit}
     */
    public function hxSerialize(serializer:Serializer):Void
    {
        throw new UnsupportedOperationException("hext.threading.Synchronizer instances cannot be unserialized.");
    }

    /**
     * @{inherit}
     */
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        throw new UnsupportedOperationException("hext.threading.Synchronizer instances cannot be unserialized.");
    }

    /**
     * @{inherit}
     */
    public function sync(fn:Closure):Void
    {
        #if (cpp || cs || java || neko)
            this.mutex.acquire();
            try {
                fn();
            } catch (ex:Dynamic) {
                this.mutex.release();
                throw ex;
            }
            this.mutex.release();
        #else
            fn();
        #end
    }
}
