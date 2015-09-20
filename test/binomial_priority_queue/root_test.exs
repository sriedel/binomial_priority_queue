defmodule BinomialPriorityQueueRootTest do
  use ExUnit.Case
  alias BinomialPriorityQueue.Root, as: BPQRoot

  test "the size of an empty root" do
    root = BPQRoot.new
    assert BPQRoot.size( root ) == 0
  end

  test "the minimum element of an empty root" do
    root = BPQRoot.new
    assert BPQRoot.min( root ) == nil
  end

  test "popping an element of an empty root" do
    root = BPQRoot.new
    assert_raise Enum.EmptyError, fn -> BPQRoot.pop( root ) end
  end

  test "the size of a one-element root" do
    root = BPQRoot.new 
           |> BPQRoot.add( "foo", 3 )

    assert BPQRoot.size( root ) == 1
  end

  test "the minimum element of a one-element root" do
    node = BPQRoot.new 
           |> BPQRoot.add( "foo", 3 )
           |> BPQRoot.min

    assert node.value == "foo"
    assert node.score == 3
    assert node.size == 1
    assert node.children == []
  end

  test "popping an element from a one-element root" do
    root = BPQRoot.new
           |> BPQRoot.add( "foo", 3 )
           |> BPQRoot.pop
    assert BPQRoot.size( root ) == 0
    assert BPQRoot.min( root ) == nil
    assert_raise Enum.EmptyError, fn -> BPQRoot.pop( root ) end 
  end

  test "the size of a 5 element queue" do
    root = BPQRoot.new
           |> BPQRoot.add( "three", 3 ) 
           |> BPQRoot.add( "one", 1 )
           |> BPQRoot.add( "five", 5 )
           |> BPQRoot.add( "two", 2 )
           |> BPQRoot.add( "four", 4 )

    assert BPQRoot.size( root ) == 5
    assert %BinomialPriorityQueue.Node{value: "one", score: 1} = BPQRoot.min( root )
    
    root = BPQRoot.pop( root )
    assert BPQRoot.size( root ) == 4
    assert %BinomialPriorityQueue.Node{value: "two", score: 2} = BPQRoot.min( root )
    root = BPQRoot.pop( root )
    assert BPQRoot.size( root ) == 3
    assert %BinomialPriorityQueue.Node{value: "three", score: 3} = BPQRoot.min( root )
    root = BPQRoot.pop( root )
    assert BPQRoot.size( root ) == 2
    assert %BinomialPriorityQueue.Node{value: "four", score: 4} = BPQRoot.min( root )
    root = BPQRoot.pop( root )
    assert BPQRoot.size( root ) == 1
    assert %BinomialPriorityQueue.Node{value: "five", score: 5} = BPQRoot.min( root )
    root = BPQRoot.pop( root )
    assert BPQRoot.size( root ) == 0
  end
end
