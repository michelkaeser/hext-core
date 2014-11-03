package hext;

/**
 * TODO
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
