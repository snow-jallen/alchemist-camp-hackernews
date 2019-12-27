defmodule Hackernews do
  @moduledoc """
  Challenge:
  1) Create new mix project and a worker that logs the title of the
  current number 1 story on HN every hour. You can get live data using
  the endpoint provided near the bottom under "New, Top and Best Stories"
  on HN's API reference and then use the top story ID to get the story's
  details from the story endpoint listed higher up on the same page.

  1) get top ids
  2) get detail for id
  3) log timestamp, id, title, url
  """

  def get_top_story_id do
    response =
      "https://hacker-news.firebaseio.com/v0/topstories.json"
      |> HTTPoison.get!

    response.body
    |> Poison.decode!
    |> Enum.at(0)
  end

  def get_story_details(id) do
    response =
      "https://hacker-news.firebaseio.com/v0/item/#{id}.json"
      |> HTTPoison.get!

    response.body
    |> Poison.decode!
  end

  def log_details(%{"id"=>id, "title"=>title, "url"=> url}) do
    filename = "hackernews.csv"
    unless File.exists?(filename) do
      IO.puts("Writing headers")
      File.write!(filename, column_names() <> "\n")
    end
    IO.puts("Writing id=#{id}; title=#{title}; url=#{url}")
    content = [[id,title,url]]
    file = File.open!(filename, [:write, :append])
    CSV.encode(content)
    |> IO.inspect
    |> Enum.each(&IO.write(file, &1))
    File.close(file)
  end

  def column_names do
    Enum.join( ~w(ID Title URL), ",")
  end

  def run do
    IO.puts("Running job...")
    get_top_story_id()
    |> get_story_details()
    |> log_details()
  end
end
