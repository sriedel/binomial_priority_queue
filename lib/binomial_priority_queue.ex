defmodule BinomialPriorityQueue do
  use GenServer

  @moduledoc """
  This module implements a priority queue using min-binomial heaps with a
  GenServer interface. Each value within the priority queue needs to have a
  score assigned, according to which its position within the queue is computed.
  
  This lends itself naturally to use unix timestamps as scores, allowing this
  module to act as a simple time-based queueing server.

  Note that traditional queuing server functionality such as persistence or
  protection against lost jobs when an exception is raised after a job is 
  removed from the queue are not part of the provided functionality as of 
  the time of this writing.

  For more information on binomial heaps, see 
  https://en.wikipedia.org/wiki/Binomial_heap
  """

  alias BinomialPriorityQueue.Heap, as: BPQHeap

  @doc """
  Starts the GenServer with the options passed.
  Returns `{ :ok, pid }` on success.
  """
  def start_link( opts \\ [] ) do
    GenServer.start_link( __MODULE__, :ok, opts )
  end

  @doc """
  Add the _value_ with score _score_ to the server provided by _server_.
  """
  def add( server, value, score ) when is_number( score ) do
    GenServer.call( server, { :add, value, score } )
  end

  @doc """
  Returns the value with the minimum score within the queue provided by
  _server_.  The value is not removed from the queue. 

  Returns _nil_ if the queue is empty.

  """
  def min( server ), do: GenServer.call( server, { :min } )

  @doc """
  Remove the minimum value from the queue provided by _server_.

  Returns `:empty`, when the queue is already empty, otherwise `:ok`.
  """
  def pop( server ), do: GenServer.call( server, { :pop } )

  @doc """
  Removes and returns the minimum value from the queue provided by _server_.
  Returns nil if the queue is empty.
  """
  def min_pop( server ), do: GenServer.call( server, { :min_pop } )

  @doc """
  Returns the number of elements within the queue provided by _server_.
  """
  def size( server ), do: GenServer.call( server, { :size } )

  @doc """
  Stops the GenServer identified by _server_.
  """
  def stop( server ), do: GenServer.call( server, { :stop } )

  def init( :ok ) do
    { :ok, BPQHeap.new }
  end

  def handle_call( { :add, value, score }, _from, queue ) do
    { :reply, :ok, BPQHeap.add( queue, value, score ) }
  end

  def handle_call( { :min }, _from, queue ) do
    { :reply, BPQHeap.min( queue ), queue }
  end

  def handle_call( { :pop }, _from, queue ) do
    case BPQHeap.size( queue ) do
      0 -> { :reply, :empty, queue }
      _ -> { :reply, :ok, BPQHeap.pop( queue ) }
    end
  end

  def handle_call( { :min_pop }, _from, queue ) do
    case BPQHeap.size( queue ) do
      0 -> { :reply, BPQHeap.min( queue ), queue }
      _ -> { :reply, BPQHeap.min( queue ), BPQHeap.pop( queue ) }
    end
  end

  def handle_call( { :size }, _from, queue ) do
    { :reply, BPQHeap.size( queue ), queue }
  end

  def handle_call( { :stop }, _from, queue ) do
    { :stop, :normal, :ok, queue }
  end
end
