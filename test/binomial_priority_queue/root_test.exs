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
end
