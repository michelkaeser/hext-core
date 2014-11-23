package hext.io;

import hext.io.Directory;
import hext.io.FileNotFoundException;
import hext.io.IOException;
import sys.FileSystem;

/**
 * The DirectoryTools utilities class adds several helpful methods to the hext.io.Directory class.
 */
class DirectoryTools
{
    /**
     * Returns the paths of all iles and directories in the directory.
     *
     * @param hext.io.Directory dir the directory to get the children for
     * @param Bool              fullPath either to return the full paths (including directories) or not
     *
     * @return Array<Path> the directory entries
     *
     * @throws hext.io.IOException           when the content could not be read
     * @throws hext.io.FileNotFoundException when the directory does not exist
     */
    public static function getChildren(dir:Directory, fullPath:Bool = false):Array<Path>
    {
        if (dir.exists()) {
            try {
                var children:Array<Path> = FileSystem.readDirectory(dir.path);
                if (fullPath) {
                    var i:Int = 0;
                    while (i < children.length) {
                        children[i] = dir.path + children[i];
                        ++i;
                    }
                }

                return children;
            } catch (ex:Dynamic) {
                throw new IOException("Error getting the directory's children.");
            }
        }

        throw new FileNotFoundException();
    }
}
