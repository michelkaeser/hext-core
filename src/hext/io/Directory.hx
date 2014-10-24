package hext.io;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.io.Path in HaxePath;
import hext.Serializable;
import hext.Stringable;
import hext.io.File;
import hext.io.FileNotFoundException;
import hext.io.IOException;
import hext.io.Path;
import sys.FileStat;
import sys.FileSystem;

/**
 * Local filesystem directory abstraction class combining various methods
 * of the Std IO hextrary and classes under the hood.
 *
 * Use cases:
 *   - Everything that includes working with FS directories.
 */
class Directory implements Serializable implements Stringable
{
    /**
     * Stores the path of the directory.
     *
     * @var hext.io.Path
     */
    public var path(default, null):Path;


    /**
     * Constructor to initialize a new Directory instance.
     *
     * @param hext.io.Path path the directory path
     */
    public function new(path:Path):Void
    {
        this.path = HaxePath.addTrailingSlash(path);
    }

    /**
     * Creates a copy of the directory and its children.
     *
     * @param hext.io.Path to the path of the copy
     *
     * @return hext.io.Directory the copied directory
     *
     * @throws hext.io.IOException when the target destination already exists
     * @throws hext.io.IOException when the copy directory could not be created
     */
    public function copy(to:Path):Directory
    {
        if (FileSystem.exists(to)) {
            throw new IOException("Target destination already exists.");
        }

        var copy:Directory = new Directory(to);
        if (copy.create()) {
            var children:Array<Path> = this.getChildren();
            for (child in children) {
                var path:Path     = this.path + child;
                var copyPath:Path = copy.path + child;
                if (FileSystem.isDirectory(path)) {
                    var directory:Directory = new Directory(path);
                    directory.copy(copyPath);
                } else {
                    var file:File = new File(path);
                    file.copy(copyPath);
                }
            }

            return copy;
        }

        throw new IOException("Error creating the directory copy.");
    }

    /**
     * Creates the directory and its parents if they do not exist.
     *
     * @return Bool true if created
     *
     * @throws hext.io.IOException if the directory could not be created
     */
    public function create():Bool
    {
        if (!this.exists()) {
            try {
                FileSystem.createDirectory(this.path);
                return true;
            } catch (ex:Dynamic) {
                throw new IOException("Error creating the directory.");
            }
        }

        return false;
    }

    /**
     * Deletes the directory from the filesystem.
     *
     * @param Bool recursive delete even if not empty
     *
     * @return Bool true if deleted
     *
     * @throws hext.io.IOException when deleting failed
     * @throws hext.io.IOException when the directory is not empty and recursive is false
     */
    public function delete(recursive:Bool = false):Bool
    {
        if (this.exists()) {
            if (this.isEmpty()) {
                try {
                    FileSystem.deleteDirectory(this.path);
                    return true;
                } catch (ex:Dynamic) {
                    throw new IOException("Error deleting the directory.");
                }
            } else {
                if (recursive) {
                    var children:Array<Path> = this.getChildren();
                    for (child in children) {
                        var path:Path = this.path + child;
                        if (FileSystem.isDirectory(path)) {
                            var directory:Directory = new Directory(path);
                            directory.delete(true);
                        } else {
                            var file:File = new File(path);
                            file.delete();
                        }
                    }

                    return this.delete(false);
                } else {
                    throw new IOException("Directory not empty.");
                }
            }

        }

        return false;
    }

    /**
     * Checks if the directory exists on the filesystem.
     *
     * @return Bool
     */
    public function exists():Bool
    {
        return FileSystem.exists(this.path) && FileSystem.isDirectory(this.path);
    }

    /**
     * Returns the paths of all iles and directories in the directory.
     *
     * @param Bool fullPath either to return the full paths (including directories) or not
     *
     * @return Array<Path> the directory entries
     *
     * @throws hext.io.IOException           when the content could not be read
     * @throws hext.io.FileNotFoundException when the directory does not exist
     */
    public function getChildren(fullPath:Bool = false):Array<Path>
    {
        if (this.exists()) {
            try {
                var children:Array<Path> = FileSystem.readDirectory(this.path);
                if (fullPath) {
                    var i:Int = 0;
                    while (i < children.length) {
                        children[i] = this.path + children[i];
                        ++i;
                    }
                    // Not so good as it creates a new Array
                    // children = children.map(function(child:Path):Path {
                    //     return this.path + child;
                    // });
                }

                return children;
            } catch (ex:Dynamic) {
                throw new IOException("Error getting the directory's children.");
            }
        }

        throw new FileNotFoundException();
    }

    /**
     * @{inherit}
     */
    @:keep
    public function hxSerialize(serializer:Serializer):Void
    {
        serializer.serialize(this.path);
    }

    /**
     * @{inherit}
     */
    @:keep
    public function hxUnserialize(unserializer:Unserializer):Void
    {
        this.path = unserializer.unserialize();
    }

    /**
     * Checks if the directory is empty.
     *
     * @return Bool true if empty
     *
     * @throws hext.io.FileNotFoundException if the directory does not exist
     */
    public function isEmpty():Bool
    {
        if (this.exists()) {
            return this.getChildren().length == 0;
        }

        throw new FileNotFoundException();
    }

    /**
     * Returns a new Directory instance by wrapping an existing filesystem dir.
     *
     * @param hext.io.Path path the directory to open
     *
     * @return hext.io.Directory
     */
    public static function open(path:Path):Directory
    {
        var directory:Directory = new Directory(path);
        if (!directory.exists()) {
            directory.create();
        }

        return directory;
    }

    /**
     * Renames/moves the directory to the new location.
     *
     * @param Path to the new location/path
     *
     * @return Bool true if renamed
     *
     * @throws hext.io.IOException if the target destination already exists
     * @throws hext.io.IOException if renaming failed even though the directory exists
     */
    public function rename(to:Path):Bool
    {
        if (FileSystem.exists(to)) {
            throw new IOException("Target destination already exists.");
        }

        if (this.exists()) {
            try {
                FileSystem.rename(this.path, to);
            } catch (ex:Dynamic) {
                throw new IOException("Error during directory renaming.");
            }
        }
        this.path = HaxePath.addTrailingSlash(to);

        return this.exists();
    }

    /**
     * Returns FileStat information on the directory.
     *
     * @return sys.FileStat
     *
     * @throws hext.io.FileNotFoundException if the directory does not exist
     */
    public function stat():FileStat
    {
        if (this.exists()) {
            return FileSystem.stat(this.path);
        }

        throw new FileNotFoundException();
    }

    /**
     * Returns a stringified version of the Directory object.
     *
     * By default, the Path behind the directory is returned.
     *
     * @return String the directory's path
     */
    public function toString():String
    {
        return this.path;
    }
}
