defmodule HedwigMopidyEvents.Responder do
  @moduledoc """
    starts pushing Mopidy events to the channel
  """

  use Hedwig.Responder

  @usage """
  <botname> mopidy events
  """
  respond ~r/mopidy events$/i, msg do
    HedwigMopidyEvents.Rooms.add(%{room: msg.room, robot: msg.robot})
    reply msg, "will do!"
  end

  @usage """
  <botname> mopidy events stop
  """
  respond ~r/mopidy events stop$/i, msg do
    HedwigMopidyEvents.Rooms.remove(%{room: msg.room, robot: msg.robot})
    reply msg, "stopping!"
  end  
end