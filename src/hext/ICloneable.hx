package hext;

/**
 * The ICloneable interface forces the implementing class
 * to offer a public API method to get a deep-copy of the current instance.
 *
 * Use cases:
 *   - The hext.utils.Reflector's clone() method checks if classes implement the
 *     ICloneable interface. This allows a dev to implement his own deep-copy mechanism
 *     rather than relying on the default one - which might be slow and unsafe.
 *
 * @generic T the type of the value the clone method returns
 */
interface ICloneable<T>
{
    /**
     * Returns a deep-copy of the current instance.
     *
     * A deep-copy makes sure every single field of the instance
     * is cloned as well, so no reference of the current and the cloned
     * object have the same reference.
     *
     * @return T the cloned this instance
     */
    public function clone():T;
}
