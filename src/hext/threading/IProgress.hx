package hext.threading;

import hext.Callback;

/**
 * IProgress instances are a great way to keep listeners updated
 * about the current progress or allow them to wait until a given progress is reached.
 *
 * Use cases:
 *   - Progress bars
 *   - Callback actions that should take place as soon as a given milestone (progress)
 *     is reached.
 */
interface IProgress
{
    /**
     * Stores the actual progress value (e.g. 0.8).
     *
     * @var Float
     */
    @:isVar public var value(get, null):Float;


    /**
     * Attaches the value listener.
     *
     * The listener is called with the new value every time the Progress' value changes.
     *
     * @param hext.Callback<Float> listener the listener to add
     *
     * @return Bool true if attached
     */
    public function attachValueListener(listener:Callback<Float>):Bool;

    /**
     * Waits until the Progress reaches the given value.
     *
     * @param Float value the value to wait for
     *
     * @throws hext.IllegalArgumentException when trying to await a value larger as possible
     */
    public function await(value:Float):Void;

    /**
     * Dettaches the listener.
     *
     * @param hext.Callback<Float> listener the listener to remove
     *
     * @return Bool true if removed
     */
    public function dettachValueListener(listener:Callback<Float>):Bool;

    /**
     * Checks if the Progress has been completed.
     *
     * @return Bool
     */
    public function isCompleted():Bool;

    /**
     * Sets the progress value.
     *
     * @param Float value the value to set
     *
     * @return Float
     *
     * @throws hext.IllegalArgumentException if the value is less than 0
     * @throws hext.IllegalArgumentException if the value is greater than 1
     */
    public function setValue(value:Float):Float;
}
