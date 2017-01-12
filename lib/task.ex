defmodule HedwigMopidyEvents.Task do
  @moduledoc """
    A task that processes events from Mopidy, formats them as messages
    and then sends them to rooms that have asked for them.
    Currently only sends track_playback_started events, but could be easily extended
  """

  alias Mopidy.{Events, TlTrack, Track, Album, Artist}
  
  def run() do
    :timer.sleep(5000) 
    Events.create_stream
    |> Enum.each(fn e -> send_event(e) end)    
    run()
  end

  defp send_event({:ok, %{event: "track_playback_started"} = event}) do    
    Enum.each(HedwigMopidyEvents.Rooms.all, fn %{room: room, robot: robot} -> 
      Hedwig.Robot.send(robot, message(room, event)) 
    end)    
  end

  defp send_event(e) do
    IO.puts("nothing to do for event #{inspect e}")
  end
  
  defp message(room, event) do
    %Hedwig.Message{
      type: "message",
      room: room,
      text: format(event)
    }
  end

  defp format(%{tl_track: %TlTrack{track: %Track{} = track}}) do
    format(track)
  end

  defp format(%Track{name: name, album: %Album{} = album, artists: artists}) do
    "♫ *#{name}* by *#{format(artists)}* from *#{format(album)}*"
  end

  defp format(%Album{name: name}) do
    "#{name}"
  end

  defp format([%Artist{}| _] = artists) do
    artists
    |> Enum.map(&format/1)
    |> Enum.join(", ")
  end

  defp format(%Artist{name: name}) do
    "#{name}"
  end

  defp format(_) do
    "unrecognized mopidy event"
  end
end
