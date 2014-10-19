package hext.util;

/**
 * The Predicator typedef defines a function/method
 * accepting an object and returns true if the objects
 * satisfies a given condition/predicate.
 *
 * Use cases:
 *   - Deciding either a function should be executed or not.
 *     The decision could be made upon the result of calling the Predicator function.
 *
 * @generic T the type of the argument the Predicator accepts
 */
typedef Predicator<T> = T->Bool;
