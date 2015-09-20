defmodule BinomialPriorityQueue.Root do
  alias BinomialPriorityQueue.Node, as: BPQNode

  def new do
    []
  end

  def add( root, value, score ) when is_number( score ) do
    node = BPQNode.new( value, score )

    add_node( new, root, node )
  end

  defp add_node( new_root, [], node ), do: Enum.reverse( [ node | new_root ] )
  defp add_node( new_root, [ h | t ], node ) do
    cond do
      h.size == node.size -> add_node( new_root, t, BPQNode.merge( node, h ) )
      h.size < node.size  -> add_node( [ h | new_root ], t, node )
      h.size > node.size  -> add_node( [ node | new_root ], t, h )
    end
  end

  def min( [] ), do: nil
  def min( root ) do
    Enum.min_by( root, &(&1.score) )
  end

  def pop( [] ), do: raise Enum.EmptyError
  def pop( root ) do
    min_node = min( root )
    root_with_tree_removed = List.delete( root, min_node )
    Enum.reduce( min_node.children, root_with_tree_removed, fn( child, new_root ) -> add_node( new, new_root, child ) end )
  end

  def size( root ) do
    root |> Enum.map( &(&1.size) ) |> Enum.sum
  end

  def to_list( root ), do: to_list( root, [] )

  defp to_list( [], acc ), do: Enum.reverse( acc )
  defp to_list( root, acc ) do
    node = min( root )
    to_list( pop( root ), [ node | acc ] )
  end
end
