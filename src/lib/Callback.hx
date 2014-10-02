package lib;

/**
 * Typedef for functions that are considered a callback (as in JS).
 *
 * Use cases:
 *   - Allowing a function caller to pass a 'callback' that is executed after some
 *     (long) running work was done.
 */
typedef Callback<T> = T->Void;
