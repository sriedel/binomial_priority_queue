defmodule BinomialPriorityQueue.Heap do
  defstruct size: 0, forrest: []

  alias BinomialPriorityQueue.Node, as: BPQNode
  alias BinomialPriorityQueue.Heap, as: BPQHeap

  @moduledoc """
  This module can be used to use a queue directly, without a GenServer.
  """

  @doc """
  Returns a new Heap structure.
  """
  @spec new() :: struct
  def new do
    %BPQHeap{}
  end
  
  defp new( size, forrest ), do: %BPQHeap{ size: size, forrest: forrest }

  @doc """
  Add the _value_ with score _score_ to the queue identified by _root_.
  Returns a new heap containing the old heap and the added value.
  """
  @spec add( struct, term, number ) :: struct
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
  
  @doc """
  Returns the minimum value of the queue identified by _root_. The value is 
  not removed from the heap structure. 

  If the queue is empty, returns _nil_.
  """
  @spec min( struct ) :: term
  def min( _root = %BPQHeap{size: 0} ), do: nil
  def min( root ) do
    Enum.min_by( root.forrest, &(&1.score) )
  end

  @doc """
  Removes the minimum element of the queue structure identified by _root_
  and returns a new heap structure with the element removed. 

  If the queue is already empty, _Enum.EmptyError_ is raised.
  """
  @struct pop( struct ) :: struct
  def pop( _root = %BPQHeap{size: 0} ), do: raise Enum.EmptyError
  def pop( root ) do
    min_node = min( root )
    root_with_tree_removed = List.delete( root.forrest, min_node )
    new_forrest = Enum.reduce( min_node.children,
                               root_with_tree_removed, 
                               fn( child, acc ) -> add_node( [], acc, child ) end )
    new( root.size - 1, new_forrest )
  end

  @doc """
  Returns the number of elements within the queue identified by _root_.
  """
  @struct size( struct ) :: non_neg_integer
  def size( root ), do: root.size

  @doc """
  Serializes the queue identified by _root_ into a list ordered by the 
  values scores.
  """
  @spec to_list( struct ) :: list
  def to_list( root ), do: to_list( root, [] )

  defp to_list( %BPQHeap{ size: 0 }, acc ), do: Enum.reverse( acc )
  defp to_list( root, acc ) do
    node = min( root )
    to_list( pop( root ), [ node | acc ] )
  end
end
