defmodule BinomialPriorityQueue.Node do
  defstruct value: nil, score: nil, size: 1, children: []

  def new( value, score ) when is_number( score ) do
    %BinomialPriorityQueue.Node{ value: value, score: score }
  end

  defp new( value, score, size, children ) do
    %BinomialPriorityQueue.Node{ value: value, score: score, size: size, children: children }
  end

  def merge( a = %BinomialPriorityQueue.Node{ score: score_a }, b = %BinomialPriorityQueue.Node{ score: score_b } ) when score_a <= score_b do
    new( a.value, a.score, a.size + b.size, [ b | a.children ] )
  end
  def merge( a, b ), do: merge( b, a )

end
