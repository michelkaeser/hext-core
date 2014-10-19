package hext.ds;

import hext.Callback;
import hext.ds.ITree;
import hext.ds.Set;
import hext.util.Comparator;

/**
 * TODO
 *
 * Use cases:
 *   - Needing a DS that allows fast checking of either an item is included or not.
 */
class BinaryTreeSet<T> extends Set<T> implements ITree<T>
{
    /**
     * Stores the Tree's root node.
     *
     * @var hext.ds.BinaryTreeSet.Node<T>
     */
    private var root:Node<T>;


    /**
     * Constructor to initialize a new BinaryTreeSet instance.
     *
     * @param hext.util.Comparator<T> comparator the Comparator used to compare items
     */
    public function new(comparator:Comparator<T>):Void
    {
        super(comparator);
        this.root = new Node<T>();
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Bool
    {
        var match:SearchResult<T> = this.find(item);
        if (match.node == null) {
            var node:Node<T> = new Node<T>(item);
            if (match.isLeft) {
                match.parent.left = node;
            } else {
                match.parent.right = node;
            }

            ++this.size;
            return true;
        }

        return false;
    }

    /**
     * @{inherit}
     */
    override public function clear():Void
    {
        super.clear();
        this.root.right = null;
    }

    /**
     * @{inherit}
     */
    override public function contains(item:T):Bool
    {
        if (!this.isEmpty()) {
            var current:Node<T> = this.root.right;
            while (current != null) {
                if (this.comparator(current.data, item) == 0) {
                    return true;
                }

                if (this.comparator(item, current.data) == 1) {
                    current = current.right;
                } else {
                    current = current.left;
                }
            }
        }

        return false;
    }

    /**
     * Runs a search for the given item and returns a SearchResult for it.
     *
     * @param T item the item to find
     *
     * @return hext.ds.BinaryTreeSet.SearchResult<T
     */
    private function find(item:T):SearchResult<T>
    {
        var match:SearchResult<T> = {
            parent: this.root,
            node:   this.root.right,
            isLeft: false
        };

        while (match.node != null) {
            if (this.comparator(match.node.data, item) == 0) {
                return match;
            }

            match.parent = match.node;
            if (this.comparator(item, match.node.data) == 1) {
                match.node = match.node.right;
                match.isLeft = false;
            } else {
                match.node = match.node.left;
                match.isLeft = true;
            }
        }

        return match;
    }

    /**
     * @{inherit}
     */
    override public function iterator():Iterator<T>
    {
        return this.toArray().iterator();
    }

    /**
     * Internal helper function used to traverse the Tree in order.
     *
     * @param hext.ds.BinaryTreeSet.Node<T> root     the root from which to start the traverse
     * @param Int                            level    the current level we are in
     * @param hext.Callback<T>              callback the callback to execute for each item
     */
    private function _traverse(root:Node<T>, level:Int = 0, callback:Callback<T>):Void
    {
        if (root != null) {
            this._traverse(root.left, level + 1, callback);
            callback(root.data);
            this._traverse(root.right, level + 1, callback);
        }
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        if (!this.isEmpty()) {
            var match:SearchResult<T> = this.find(item);
            if (match.node != null) {
                if (match.node.left == null && match.node.right == null) { // no child leafs, simply unset at parent node
                    if (match.isLeft) {
                        match.parent.left = null;
                    } else {
                        match.parent.right = null;
                    }
                } else if ((match.node.left == null) != (match.node.right == null)) { // only one child leaf
                    if (match.isLeft) {
                        match.parent.left = (match.node.left != null) ? match.node.left : match.node.right;
                    } else {
                        match.parent.right = (match.node.left != null) ? match.node.left : match.node.right;
                    }
                } else { // two leafs
                    var current:Node<T> = match.node.left;
                    while (current.right != null) {
                        current = current.right;
                    }
                    this.remove(current.data);
                    match.node.data = current.data;
                }

                --this.size;
                return true;
            }
        }

        return false;
    }

    /**
     * @{inherit}
     */
    override public function toArray():Array<T>
    {
        var target:Array<T> = new Array<T>();
        if (!this.isEmpty()) {
            this._traverse(this.root.right, 0, function(node:T):Void {
                target.push(node);
            });
        }

        return target;
    }
}


/**
 * Wrapper class for items stored within the BinaryTree.
 *
 * @generic T the type of item the Node wraps
 */
private class Node<T>
{
    public var left:Node<T>;
    public var right:Node<T>;
    public var data:Null<T>;

    public function new(?data:T):Void
    {
        this.data = data;
    }
}


/**
 * Typedef returned by find() holding information about
 * where the item has been found (or not).
 */
private typedef SearchResult<T> =
{
    var parent:Node<T>;
    var node:Node<T>;
    var isLeft:Bool;
};
