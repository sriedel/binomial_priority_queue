defmodule BinomialPriorityQueue.Heap do
  defstruct size: 0, forrest: []

  alias BinomialPriorityQueue.Node, as: BPQNode
  alias BinomialPriorityQueue.Heap, as: BPQHeap

  def new do
    %BPQHeap{}
  end
  
  defp new( size, forrest ), do: %BPQHeap{ size: size, forrest: forrest }

  def add( root, value, score ) when is_number( score ) do
    node = BPQNode.new( value, score )

    new_forrest = add_node( [], root.forrest, node ) 
    new( root.size + 1, new_forrest )
  end

  defp add_node( acc, _forrest = [], node ), do: Enum.reverse( [ node | acc ] )
  defp add_node( acc, _forrest = [ h | t ], node ) do
    cond do
      h.size == node.size -> add_node( acc, t, BPQNode.merge( node, h ) )
      h.size < node.size  -> add_node( [ h | acc ], t, node )
      h.size > node.size  -> add_node( [ node | acc ], t, h )
    end
  end

  def min( _root = %BPQHeap{size: 0} ), do: nil
  def min( root ) do
    Enum.min_by( root.forrest, &(&1.score) )
  end

  def pop( _root = %BPQHeap{size: 0} ), do: raise Enum.EmptyError
  def pop( root ) do
    min_node = min( root )
    root_with_tree_removed = List.delete( root.forrest, min_node )
    new_forrest = Enum.reduce( min_node.children,
                               root_with_tree_removed, 
                               fn( child, acc ) -> add_node( [], acc, child ) end )
    new( root.size - 1, new_forrest )
  end

  def size( root ) do
    root.size
  end

  def to_list( root ), do: to_list( root, [] )

  defp to_list( %BPQHeap{ size: 0 }, acc ), do: Enum.reverse( acc )
  defp to_list( root, acc ) do
    node = min( root )
    to_list( pop( root ), [ node | acc ] )
  end
end
