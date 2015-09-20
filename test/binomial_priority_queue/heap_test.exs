defmodule BinomialPriorityQueueHeapTest do
  use ExUnit.Case
  alias BinomialPriorityQueue.Heap, as: BPQHeap

  test "the size of an empty heap" do
    heap = BPQHeap.new
    assert BPQHeap.size( heap ) == 0
  end

  test "the minimum element of an empty heap" do
    heap = BPQHeap.new
    assert BPQHeap.min( heap ) == nil
  end

  test "popping an element of an empty heap" do
    heap = BPQHeap.new
    assert_raise Enum.EmptyError, fn -> BPQHeap.pop( heap ) end
  end

  test "the size of a one-element heap" do
    heap = BPQHeap.new 
           |> BPQHeap.add( "foo", 3 )

    assert BPQHeap.size( heap ) == 1
  end

  test "the minimum element of a one-element heap" do
    node = BPQHeap.new 
           |> BPQHeap.add( "foo", 3 )
           |> BPQHeap.min

    assert node.value == "foo"
    assert node.score == 3
    assert node.size == 1
    assert node.children == []
  end

  test "popping an element from a one-element heap" do
    heap = BPQHeap.new
           |> BPQHeap.add( "foo", 3 )
           |> BPQHeap.pop
    assert BPQHeap.size( heap ) == 0
    assert BPQHeap.min( heap ) == nil
    assert_raise Enum.EmptyError, fn -> BPQHeap.pop( heap ) end 
  end

  test "the size of a 5 element queue" do
    heap = BPQHeap.new
           |> BPQHeap.add( "three", 3 ) 
           |> BPQHeap.add( "one", 1 )
           |> BPQHeap.add( "five", 5 )
           |> BPQHeap.add( "two", 2 )
           |> BPQHeap.add( "four", 4 )

    assert BPQHeap.size( heap ) == 5
    assert %BinomialPriorityQueue.Node{value: "one", score: 1} = BPQHeap.min( heap )
    mapped_scores = BPQHeap.to_list( heap ) |> Enum.map( &(&1.score) )
    assert mapped_scores == [ 1, 2, 3, 4, 5 ]
    
    heap = BPQHeap.pop( heap )
    assert BPQHeap.size( heap ) == 4
    assert %BinomialPriorityQueue.Node{value: "two", score: 2} = BPQHeap.min( heap )
    heap = BPQHeap.pop( heap )
    assert BPQHeap.size( heap ) == 3
    assert %BinomialPriorityQueue.Node{value: "three", score: 3} = BPQHeap.min( heap )
    heap = BPQHeap.pop( heap )
    assert BPQHeap.size( heap ) == 2
    assert %BinomialPriorityQueue.Node{value: "four", score: 4} = BPQHeap.min( heap )
    heap = BPQHeap.pop( heap )
    assert BPQHeap.size( heap ) == 1
    assert %BinomialPriorityQueue.Node{value: "five", score: 5} = BPQHeap.min( heap )
    heap = BPQHeap.pop( heap )
    assert BPQHeap.size( heap ) == 0
  end
end
