defmodule BinomialPriorityQueueNodeTest do
  use ExUnit.Case
  alias BinomialPriorityQueue.Node, as: BPQNode

  test "new with defaults" do
    value = "foo"
    score = 3
    node = BPQNode.new( value, score )
    assert node.value ==  value 
    assert node.score ==  score
    assert node.size ==  1
    assert node.children ==  []
  end

  test "merging two nodes, where a has a smaller score than b" do
    node_a = BPQNode.new( "foo", 2 )
    node_b = BPQNode.new( "bar", 3 )

    merged_node = BPQNode.merge( node_a, node_b )
    assert merged_node.value == "foo"
    assert merged_node.score == 2
    assert merged_node.size == 2
    assert merged_node.children == [ node_b ]
  end

  test "merging two nodes with the same score" do
    node_a = BPQNode.new( "foo", 2 )
    node_b = BPQNode.new( "bar", 2 )

    merged_node = BPQNode.merge( node_a, node_b )
    assert merged_node.value == "foo"
    assert merged_node.score == 2
    assert merged_node.size == 2
    assert merged_node.children == [ node_b ]
  end

  test "merging two nodes, where a has a larger score than b" do
    node_a = BPQNode.new( "foo", 3 )
    node_b = BPQNode.new( "bar", 2 )

    merged_node = BPQNode.merge( node_a, node_b )
    assert merged_node.value == "bar"
    assert merged_node.score == 2
    assert merged_node.size == 2
    assert merged_node.children == [ node_a ]
  end

end
