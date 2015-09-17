defmodule Tree do
  def new( value, score ), do: { value, score, 1, [] }
  def size( { _, _, size, _ } ), do: size

  def merge( a = { value_a, score_a, size_a, children_a }, b = { _, score_b, size_b, _ } ) when score_a <= score_b do
    { value_a, score_a, size_a + size_b, [ b | children_a ] }
  end

  def merge( a, b ), do: merge( b, a )

  def min( { value, score, _, _ } ), do: { value, score }
 
  def remove_min( { value, score, _, children } ) do
    { value, score, children }
  end

end
