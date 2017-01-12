defmodule HedwigMopidyEvents.Rooms do
  
  def start_link do
    Agent.start_link(&MapSet.new/0, name: __MODULE__)
  end

  def add(room) do
    Agent.update(__MODULE__, &MapSet.put(&1, room))
  end

  def remove(room) do
    Agent.update(__MODULE__, &MapSet.delete(&1, room))
  end

  def all do
    Agent.get(__MODULE__, &(&1))
  end

end