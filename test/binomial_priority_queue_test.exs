defmodule BinomialPriorityQueueTest do
  use ExUnit.Case

  alias BinomialPriorityQueue, as: BPQ

  setup do
    {:ok, server} = BPQ.start_link
    {:ok, server: server}
  end

  test "stopping the server", %{server: server} do
    assert :ok = BPQ.stop( server )
  end

  test "the size of an empty queue", %{server: server}  do
    assert BPQ.size( server ) == 0
  end

  test "the minimum element of an empty queue", %{server: server}  do
    assert BPQ.min( server ) == nil
  end

  test "popping from an empty queue", %{server: server} do
    assert BPQ.pop( server ) == :empty
  end

  test "the size of a one-element queue", %{server: server}  do
    BPQ.add( server, "foo", 3 )
    assert BPQ.size( server ) == 1
  end

  test "the minimum element of a one-element queue", %{server: server}  do
    BPQ.add( server, "foo", 3 )
    node = BPQ.min( server )

    assert node.value == "foo"
    assert node.score == 3
    assert node.size == 1
    assert node.children == []
  end

  test "popping an element from a one-element root", %{server: server}  do
    BPQ.add( server, "foo", 3 )
    assert BPQ.pop( server ) == :ok
    assert BPQ.size( server ) == 0
    assert BPQ.min( server ) == nil
  end

  test "the size of a 5 element queue", %{server: server}  do
    BPQ.add( server, "three", 3 ) 
    BPQ.add( server, "one", 1 )
    BPQ.add( server, "five", 5 )
    BPQ.add( server, "two", 2 )
    BPQ.add( server, "four", 4 )

    assert BPQ.size( server ) == 5
    assert %BinomialPriorityQueue.Node{value: "one", score: 1} = BPQ.min( server )
    
    BPQ.pop( server )
    assert BPQ.size( server ) == 4
    assert %BinomialPriorityQueue.Node{value: "two", score: 2} = BPQ.min( server )
    BPQ.pop( server )
    assert BPQ.size( server ) == 3
    assert %BinomialPriorityQueue.Node{value: "three", score: 3} = BPQ.min( server )
    BPQ.pop( server )
    assert BPQ.size( server ) == 2
    assert %BinomialPriorityQueue.Node{value: "four", score: 4} = BPQ.min( server )
    BPQ.pop( server )
    assert BPQ.size( server ) == 1
    assert %BinomialPriorityQueue.Node{value: "five", score: 5} = BPQ.min( server )
    BPQ.pop( server )
    assert BPQ.size( server ) == 0
  end

  test "the min_pop operation", %{server: server } do
    BPQ.add( server, "three", 3 ) 
    BPQ.add( server, "one", 1 )
    BPQ.add( server, "five", 5 )
    BPQ.add( server, "two", 2 )
    BPQ.add( server, "four", 4 )

    min_node = BPQ.min_pop( server )
    assert min_node.score == 1
    assert min_node.value == "one"

    assert BPQ.size( server ) == 4
    new_min_node = BPQ.min( server )
    assert new_min_node.score == 2
    assert new_min_node.value == "two"
  end

end
