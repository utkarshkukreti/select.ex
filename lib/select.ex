defmodule Select do
  def parse(string) do
    :mochiweb_html.parse(string)
  end

  def matches?(node, func) when is_function(func, 1) do
    func.(node)
  end
  def matches?({name, _, _}, {:name, name}), do: true
  def matches?(_, {:name, _}), do: false
end
