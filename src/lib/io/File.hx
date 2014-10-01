package lib.io;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.io.Path in HaxePath;
import lib.Stringable;
import lib.io.FileNotFoundException;
import lib.io.IOException;
import lib.io.Path;
import sys.FileStat;
import sys.FileSystem;
import sys.io.File in HaxeFile;
import sys.io.FileInput;
import sys.io.FileOutput;

using lib.io.FileTools;

/**
 * Local filesystem file abstraction class combining various methods
 * of the Std File/IO library and classes under the hood.
 */
class File implements Stringable
{
    /**
     * Property to access the file's extension.
     *
     * @var Null<String>
     */
    public var ext(get, never):Null<String>;

    /**
     * Property to access the file's name.
     *
     * @var Null<String>
     */
    public var name(get, never):Null<String>;

    /**
     * Stores the path of the file.
     *
     * @var lib.io.Path
     */
    public var path(default, null):Path;

    /**
     * Property to access the file's size.
     *
     * @var Int
     */
    public var size(get, never):Int;


    /**
     * Constructor to initialize a new File instance.
     *
     * @param lib.io.Path path the file file
     */
    public function new(path:Path):Void
    {
        this.path = path;
    }

    /**
     * Creates a copy of the file and its content.
     *
     * @param lib.io.Path to the path of the copy
     *
     * @return lib.io.File to copied file
     *
     * @throws lib.io.IOException when the target destination already exists
     * @throws lib.io.IOException when the file content could not be copied
     * @throws lib.io.IOException when the file could not be created
     */
    public function copy(to:Path):File
    {
        if (FileSystem.exists(to)) {
            throw new IOException("Target destination already exists.");
        }

        var copy:File = new File(to);
        if (copy.create()) {
            if (!this.isEmpty()) {
                try {
                    HaxeFile.copy(this.path, to);
                } catch (ex:Dynamic) {
                    throw new IOException(ex);
                }
            }

            return copy;
        }

        throw new IOException("Error creating the copy of the file.");
    }

    /**
     * Creates the file if it does not exist.
     *
     * If a directory exists at the given path, false is returned as well.
     *
     * @return Bool true if created
     *
     * @throws lib.io.IOException if the file could not be opened/created
     */
    public function create():Bool
    {
        if (!FileSystem.exists(this.path)) {
            try {
                var writer:FileOutput = HaxeFile.write(this.path);
                writer.close();
                return true;
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        return false;
    }

    /**
     * Deletes the file from the filesystem.
     *
     * @return Bool true if deleted
     *
     * @throws lib.io.IOException when deleting failed
     */
    public function delete():Bool
    {
        if (this.exists()) {
            try {
                FileSystem.deleteFile(this.path);
                return true;
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        return false;
    }

    /**
     * Checks if the file exists.
     *
     * @return Bool
     */
    public function exists():Bool
    {
        return FileSystem.exists(this.path) && !FileSystem.isDirectory(this.path);
    }

    /**
     * Returns the extension.
     *
     * If the file doesn't exist, null is returned.
     *
     * @return Null<String> the file's extension
     */
    private function get_ext():Null<String>
    {
        if (this.exists()) {
            return HaxePath.extension(this.path);
        }

        return null;
    }

    /**
     * Returns the name.
     *
     * If the file doesn't exist, null is returned.
     *
     * @return Null<String> the file's name
     */
    private function get_name():Null<String>
    {
        if (this.exists()) {
            return HaxePath.withoutDirectory(this.path);
        }

        return null;
    }

    /**
     * Returns the size of the file content in bytes.
     *
     * If the file does not exist, -1 is returned.
     *
     * @return Int the size in bytes
     */
    private function get_size():Int
    {
        if (this.exists()) {
            return this.stat().size;
        }

        return -1;
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
     * Checks if the file is empty.
     *
     * @return Bool true if empty
     *
     * @throws lib.io.FileNotFoundException if the file does not exist
     */
    public function isEmpty():Bool
    {
        if (this.exists()) {
            return this.size == 0;
        }

        throw new FileNotFoundException();
    }

    /**
     * Returns a new File instance by wrapping an existing filesystem file.
     *
     * @param lib.io.Path path the file to open
     *
     * @return lib.io.File
     */
    public static function open(path:Path):File
    {
        var file:File = new File(path);
        if (!file.exists()) {
            file.create();
        }

        return file;
    }

    /**
     * Renames/moves the file to the new location.
     *
     * If the file did not exist, the renamed version is not created on the filesystem.
     *
     * @param Path to the new location/path
     *
     * @return Bool true if renamed on filesystem
     *
     * @throws lib.io.IOException if the target destination already exists
     * @throws lib.io.IOException if renaming failed even though the file exists
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
                throw new IOException(ex);
            }
        }
        this.path = to;

        return this.exists();
    }

    /**
     * Returns FileStat information on the file.
     *
     * @return sys.FileStat
     *
     * @throws lib.io.FileNotFoundException if the file does not exist
     */
    public function stat():FileStat
    {
        if (this.exists()) {
            return FileSystem.stat(this.path);
        }

        throw new FileNotFoundException();
    }

    /**
     * Returns a stringified version of the File object.
     *
     * By default, the path behind the file is returned.
     *
     * @return String the file's path
     */
    public function toString():String
    {
        return this.path;
    }
}
