defmodule HackernewsTest do
  use ExUnit.Case
  doctest Hackernews

  test "greets the world" do
    assert Hackernews.hello() == :world
  end
end
