defmodule Select do
  def parse(string) do
    :mochiweb_html.parse(string)
  end
end
