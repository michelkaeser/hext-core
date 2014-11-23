package hext.io;

import hext.io.Bits;

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
     * @var hext.io.Bits
     */
    @:final private var bits:Bits;

    /**
     * Stores the number of total Bits in the Bits instance.
     *
     * @var Int
     */
    @:final private var nbits:Int;

    /**
    * Stores the current index/position.
    *
    * @var Int
    */
    private var position:Int;


    /**
     * Constructor to initialize a new BitsIterator instance.
     *
     * @param hext.io.Bits bits the Bits to iterate over
     */
    public function new(bits:Bits):Void
    {
        this.bits     = bits;
        this.nbits    = bits.length << 3;
        this.position = 0;
    }

    /**
     * Checks if there is another bit remaining.
     *
     * @return Bool
     */
    public function hasNext():Bool
    {
        return this.position < this.nbits;
    }

    /**
     * Returns the next Bit.
     *
     * @return hext.io.Bit
     */
    public function next():Bit
    {
        return this.bits[this.position++];
    }
 }
