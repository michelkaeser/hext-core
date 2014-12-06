package hext.io;

import sys.io.File in HaxeFile;
import sys.io.FileInput;
import sys.io.FileOutput;
import haxe.io.Bytes;
import hext.io.File;
import hext.io.FileNotFoundException;
import hext.io.IOException;

/**
 * The FileTools utilities class adds several helpful methods to the hext.io.File class.
 */
@:final
class FileTools
{
    /**
     * @see hext.io.FileTools.write()
     *
     * Instead of overwriting existing content, it is appended.
     */
    public static function append(file:File, binary:Bool = true):FileOutput
    {
        if (file.exists()) {
            try {
                return HaxeFile.append(file.path, binary);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        throw new FileNotFoundException();
    }

    /**
     * Retrieves the binary content of the file.
     *
     * @param hext.io.File file the file to get the bytes of
     *
     * @return haxe.io.Bytes the file's bytes
     *
     * @throws hext.io.FileNotFoundException when the file does not exist
     * @throws hext.io.IOException           when getting the bytes fails
     */
    public static function getBytes(file:File):Bytes
    {
        if (file.exists()) {
            try {
                return HaxeFile.getBytes(file.path);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        throw new FileNotFoundException();
    }

    /**
     * Retrieves the content of the file as a String.
     *
     * @param hext.io.File file the file to get the content of
     *
     * @return String the file's content
     *
     * @throws hext.io.FileNotFoundException when the file does not exist
     * @throws hext.io.IOException           when getting the content fails
     */
    public static function getContent(file:File):String
    {
        if (file.exists()) {
            try {
                return HaxeFile.getContent(file.path);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        throw new FileNotFoundException();
    }

    /**
     * Returns a FileInput handle to the file.
     *
     * @param hext.io.File file   the file to read from
     * @param Bool         binary open the file in binary mode or not
     *
     * @return sys.io.FileInput the input handle
     *
     * @throws hext.FileNotFoundException when the file does not exist
     * @throws hext.IOException           when creating an input handle fails
     */
    public static function read(file:File, binary:Bool = true):FileInput
    {
        if (file.exists()) {
            try {
                return HaxeFile.read(file.path, binary);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        throw new FileNotFoundException();
    }

    /**
     * Stores bytes in the file in binary mode.
     *
     * @param hext.io.File file  the file to save the bytes in
     * @param Bytes        bytes the bytes to store
     *
     * @throws hext.FileNotFoundException when the file does not exist
     * @throws hext.IOException           when saving the bytes fails
     */
    public static function saveBytes(file:File, bytes:Bytes):Void
    {
        if (file.exists()) {
            try {
                HaxeFile.saveBytes(file.path, bytes);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        } else {
            throw new FileNotFoundException();
        }
    }

    /**
     * Stores content in the file.
     *
     * @param hext.io.File file    the file to save to
     * @param String       content the content to write to the file
     *
     * @throws hext.io.FileNotFoundException when the file does not exist
     * @throws hext.io.IOException           when saving the content fails
     */
    public static function saveContent(file:File, content:String):Void
    {
        if (file.exists()) {
            try {
                HaxeFile.saveContent(file.path, content);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        } else {
            throw new FileNotFoundException();
        }
    }

    /**
     * Returns a FileOutput handle to the file.
     *
     * @param hext.io.File file the file to write to
     * @param Bool         binary open the file in binary mode or not
     *
     * @return sys.io.FileOutput the output handle
     *
     * @throws hext.FileNotFoundException when the file does not exist
     * @throws hext.IOException           when creating an output handle fails
     */
    public static function write(file:File, binary:Bool = true):FileOutput
    {
        if (file.exists()) {
            try {
                return HaxeFile.write(file.path, binary);
            } catch (ex:Dynamic) {
                throw new IOException(ex);
            }
        }

        throw new FileNotFoundException();
    }
}
