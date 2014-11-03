package hext;

import haxe.Serializer;
import haxe.Unserializer;

/**
 * Interface grouping the two internal Haxe functions that can be overriden
 * to add custom un-/serialization behavior to your own structure.
 *
 * Use cases:
 *   - A backup/restore system. Only data might need to be backuped/restored, but not
 *     meta data or synchronization 'tools'. So one writes a custom serialization implementation.
 *
 * @link http://haxe.org/manual/std-serialization.html
 */
interface ISerializable
{
    /**
     * Method that is called by the serializer.
     *
     * Implementing this method allows one to control how the current instance
     * is serialized.
     *
     * Attn: You may need to add the '@:keep' meta to your implementation
     * so DCE doesn't erase your implementation.
     *
     * @param haxe.Serializer serializer the Serializer that does the current job
     */
    @:keepSub
    public function hxSerialize(serializer:Serializer):Void;

    /**
     * Method to be called by the unserializer.
     *
     * Implementing this method allows one to control how the current instance
     * is unserialized.
     *
     * Attn: You may need to add the '@:keep' meta to your implementation
     * so DCE doesn't erase your implementation.
     *
     * @param haxe.Unserializer unserializer the Unserializer used for current unserialization
     */
    @:keepSub
    public function hxUnserialize(unserializer:Unserializer):Void;
}
