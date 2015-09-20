defmodule BinomialPriorityQueue do
  use GenServer

  alias BinomialPriorityQueue.Root, as: BPQRoot

  def start_link( opts \\ [] ) do
    GenServer.start_link( __MODULE__, :ok, opts )
  end

  def add( server, value, score ) when is_number( score ) do
    GenServer.call( server, { :add, value, score } )
  end

  def min( server ), do: GenServer.call( server, { :min } )

  def pop( server ), do: GenServer.call( server, { :pop } )

  def size( server ), do: GenServer.call( server, { :size } )

  def stop( server ), do: GenServer.call( server, { :stop } )

  def init( :ok ) do
    { :ok, BPQRoot.new }
  end

  def handle_call( { :add, value, score }, _from, queue ) do
    { :reply, :ok, BPQRoot.add( queue, value, score ) }
  end

  def handle_call( { :min }, _from, queue ) do
    { :reply, BPQRoot.min( queue ), queue }
  end

  def handle_call( { :pop }, _from, queue ) do
    { :reply, :ok, BPQRoot.pop( queue ) }
  end

  def handle_call( { :size }, _from, queue ) do
    { :reply, BPQRoot.size( queue ), queue }
  end

  def handle_call( { :stop }, _from, queue ) do
    { :stop, :normal, :ok, queue }
  end
end
