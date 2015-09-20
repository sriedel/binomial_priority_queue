defmodule BinomialPriorityQueue.Node do
  defstruct value: nil, score: nil, size: 1, children: []

  def new( value, score, size \\ 1, children \\ [] ) 
    when is_number( score ) 
     and is_number( size ) 
     and is_list( children ) do 
    %BinomialPriorityQueue.Node{ value: value, score: score, size: size, children: children }
  end

  def merge( a = %BinomialPriorityQueue.Node{ score: score_a }, b = %BinomialPriorityQueue.Node{ score: score_b } ) when score_a <= score_b do
    new( a.value, a.score, a.size + b.size, [ b | a.children ] )
  end
  def merge( a, b ), do: merge( b, a )

end
