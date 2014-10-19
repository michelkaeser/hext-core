package hext.utils;

/**
 * Reflection methods/algorithms wrapper class that provides various
 * methods dedicated to getting information about an object instance.
 */
class Reflector
{
    /**
     * Compares the two objects.
     *
     * @see hext.utils.Comparator
     *
     * @param T x the object based on which the return value is calculated
     * @param T y the object to compare against
     *
     * @return Int
     */
    public static function compare<T>(x:T, y:T):Int
    {
        if (x != y) {
            var diff:Int = Reflect.compare(x, y);
            if (diff != 0) {
                return (diff < 0) ? -1 : 1;
            }
        }

        return 0;
    }
}
