package lib.util;

/**
 * The Comparator typedef defines a function/method
 * accepting two objects of the same type that should
 * return:
 *   - -1 if the first object is "less than" the second
 *   -  0 if both objects are equal
 *   -  1 if the second object is "greater than" the first
 *
 * Use cases:
 *   - A class saving its data in order. The class needs to know how data should be sorted
 *     for that, so the developer can allow passing in a function that can compare items.
 */
typedef Comparator<T> = T->T->Int;
