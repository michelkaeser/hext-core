package lib.io;

import lib.io.Bits;

/**
 * Iterator class to traverse each Bit of a Bits abstract.
 *
 * @see http://api.haxe.org/Iterator.html
 */
class BitsIterator
{
    /**
     * Stores the Bits over which we iterate.
     *
     * @var lib.io.Bits
     */
    private var bits:Bits;

    /**
    * Stores current index/position.
    *
    * @var Int
    */
    private var position:Int;


    /**
     * Constructor to initialize a new BitsIterator instance.
     *
     * @param lib.io.Bits bits the Bits to iterate over
     */
    public function new(bits:Bits):Void
    {
        this.bits     = bits;
        this.position = 0;
    }

    /**
     * Checks if there is another bit remaining.
     *
     * @return Bool
     */
    public function hasNext():Bool
    {
        return this.position < (this.bits.length << 3);
    }

    /**
     * Returns the next Bit.
     *
     * @return lib.io.Bit
     */
    public function next():Bit
    {
        return this.bits[this.position++];
    }
 }
