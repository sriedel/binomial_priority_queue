defmodule Root do
  def new do
    []
  end

  def add( root, { value, score } ) when is_number( score ) do
    unitary_tree = Tree.new( value, score )

    add_tree( new, Enum.reverse( root ), unitary_tree )
  end

  defp add_tree( new_root, [], tree ), do: [ tree | new_root ]
  defp add_tree( new_root, [ h ], tree ) do
    cond do
      Tree.size( h ) == Tree.size( tree ) -> add_tree( new_root, [], Tree.merge( tree, h ) )
      Tree.size( h ) < Tree.size( tree )  -> add_tree( [ h | new_root ], [], tree )
      Tree.size( h ) > Tree.size( tree )  -> add_tree( [ tree | new_root ], [], h )
    end
  end
  defp add_tree( new_root, [ h | t ], tree ) do
    cond do
      Tree.size( h ) == Tree.size( tree ) -> add_tree( new_root, t, Tree.merge( tree, h ) )
      Tree.size( h ) < Tree.size( tree )  -> add_tree( [ h | new_root ], t, tree )
      Tree.size( h ) > Tree.size( tree )  -> add_tree( [ tree | new_root ], t, h )
    end
  end

  def min( root ) do
    Enum.min_by( root, fn( tree ) -> { _, score } = Tree.min( tree ) ; score end ) |> Tree.min
  end

  def pop( root ) do
    min_tree = Enum.min_by( root, fn( tree ) -> { _, score } = Tree.min( tree ) ; score end )
    { value, score, children } = Tree.remove_min( min_tree )
    root_with_tree_removed = List.delete( root, min_tree )
    new_root = Enum.reduce( children, root_with_tree_removed, fn( child, new_root ) -> add_tree( new, new_root, child ) end )
    { new_root, value, score }
  end
end
