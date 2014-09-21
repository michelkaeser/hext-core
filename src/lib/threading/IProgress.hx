package lib.threading;

import lib.Callback;

/**
 *
 */
interface IProgress
{
    /**
     * Stores the actual progress value (e.g. 0.8).
     *
     * @var Float
     */
    /* @:isVar */ public var value(get, set):Float;

    /**
     * Attaches the value listener.
     *
     * The listener is called with the new value every time the Progress' value changes.
     *
     * @param lib.Callback<Float> listener the listener to add
     *
     * @return Bool true if attached
     */
    public function attachValueListener(listener:Callback<Float>):Bool;

    /**
     * Waits until the Progress reaches the given value.
     *
     * @var Float value the value to wait for
     *
     * @throws lib.IllegalArgumentException when trying to await a value larger as possible
     */
    public function await(value:Float):Void;

    /**
     * Dettaches the listener.
     *
     * @param lib.Callback<Float> listener the listener to remove
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
}
