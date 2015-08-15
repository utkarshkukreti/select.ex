defmodule Select do
  def parse(string) do
    :mochiweb_html.parse(string)
  end

  def matches?(node, func) when is_function(func, 1) do
    func.(node)
  end
  def matches?({name, _, _}, {:name, name}), do: true
  def matches?(_, {:name, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr}) do
    attrs |> Enum.any?(fn {k, _} -> k == attr end)
  end
  def matches?(_, {:attr, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr, value}) do
    attrs |> Enum.any?(fn {k, v} -> k == attr and v == value end)
  end
  def matches?(_, {:attr, _, _}), do: false
  def matches?(node, {:and, a, b}), do: matches?(node, a) and matches?(node, b)
end
