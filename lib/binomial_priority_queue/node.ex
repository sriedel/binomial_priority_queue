defmodule BinomialPriorityQueue.Node do
  defstruct value: nil, score: nil, size: 1, children: []

  alias BinomialPriorityQueue.Node, as: BPQNode

  def new( value, score ) when is_number( score ) do
    %BPQNode{ value: value, score: score }
  end

  defp new( value, score, size, children ) do
    %BPQNode{ value: value, score: score, size: size, children: children }
  end

  def merge( a = %BPQNode{ score: score_a }, b = %BPQNode{ score: score_b } ) when score_a <= score_b do
    new( a.value, a.score, a.size + b.size, [ b | a.children ] )
  end
  def merge( a, b ), do: merge( b, a )

end
